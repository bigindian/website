markdown = require("markdown").markdown


Model = module.exports = (Elasticsearch, BaseModel, NewsStories, NewsVotes) ->
  # **ACTIVITY_WEIGHT** Amount that any activity inside of the comment gets.
  ACTIVITY_WEIGHT = 10

  # **CREATION_WINDOW** The window variable is used narrow down how effective
  # the creation date is when the comment's hotness is calculated. A smaller
  # window allows lesser activity before the comment makes it to the front page.
  # A bigger window allows more room for old comments to become popular with
  # upvotes.
  #
  #! As the site grows, you might want to shrink this down to 12 or so.
  CREATION_WINDOW = 60 * 60 * 1.0

  new class CommentsModel extends BaseModel
    tableName: "news_comments"

    create: (storyID, data) ->
      #! First find the story for which we are adding the comment
      NewsStories.get(storyID).then (story) =>
        #! Prepare the strucutre of the new comment
        newComment =
          content_markdown: data.content
          content: markdown.toHTML data.content
          created_by: data.created_by
          created_by_uname: data.created_by_uname
          parent: data.parent
          story: storyID
          slug: @createSlug()
          meta:
            storyTitle: story.get "title"
            storySlug: story.get "slug"

        #! Create the new comment!
        @model.forge(newComment).save().then (comment) ->
          #! increment the comments count for the given story.
          story.increaseCommentsCount()

          #! Return the newly created comment
          comment


    createChild: (id, data) ->
      #! Add the parent comment's id in the body
      data.parent = id

      #! Then fetch the parent and then create the child!
      @get(id).then (parentComment) => @create parentComment.get("story"), data


    top: (buildQuery, options={}) ->
      options.order = hotness: "DESC"
      @query buildQuery, options


    findByParent: (parentId, options={}) ->
      buildQuery = (qb) -> qb.where "parent", parentId
      options.order ?= hotness: "DESC"
      options.withRelated ?= ["created_by"]
      @query buildQuery, options


    extends:
      created_by: -> @belongsTo "users", "created_by"


      upvote: (user_id) ->
        #! Try to add the vote into the votes table
        NewsVotes.create
          comment: @id
          user: user_id

        #! If the upvote could be added properly then we save the model!
        .then =>
          #! Update the hotness and the upvotes counter
          @set "votes_count", 1 + @get "votes_count"
          # @updateHotness()
          @save()


      ###
      **getScore()** Helper function to calculate the score. The score should only be a
      function of the upvotes and downvotes.

      ```
      Comments.model.getScore() # -> 30
      ```
      ###
      getScore: -> @get("votes_count") or 1


      ###
      **updateHotness()** Calculates and updates the hotness of the current
      comment. This function can be chained with other bookshelf functions.

      ```
      Comments.model.updateHotness.save()
      ```
      ###
      updateHotness: ->
        # Get the creation date and the score first.
        createdDate = Number new Date(@get "created_at").getTime() or Date.now()
        score = @get "votes_count"

        #! Don't immediately kill stories at 0. bump them up by one
        if score is 0 then score += 1

        #! Calculate the comment activity's score
        activityScore = (Math.abs(score + 1)) * ACTIVITY_WEIGHT

        #! Now using the log function is really nice because it evens out
        #! activity after a bunch of comments; Calculate how much points the
        #! score equals to.
        activityPoints = Math.log Math.max(activityScore, 1), 10

        #! Now with the acitvityPoints set, decide if the comment should be
        #! punished or rewared by its score.
        if score > 0 then rewardOrPunish = 1
        else if score <= 0 then rewardOrPunish = -1
        activityPoints = activityPoints * rewardOrPunish

        #! The creation points is set so that newer posts get more hotness than
        #! older ones. The window variable is used narrow down how effective
        #! already trending ones will take the top spot.
        creationPoints = createdDate / CREATION_WINDOW

        #! The final hotness is simply the sum of all the different points.
        hotness = activityPoints + creationPoints

        #! Round off the hotness so that postgres stays happy and set it to the
        #! model!
        #! See http://stackoverflow.com/questions/11832914/round-to-at-most-2-decimal-places-in-javascript
        @set "hotness", Math.round(hotness * 10 * 7)/(10 * 7)
        @set "raw_hotness", Math.round(activityPoints * 10 * 7)/(10 * 7)

        #! Return this instance to allow chaining.
        this


      ###
      **onSave()** Update the hotness of the comment every time it gets saved into
      the DB.

      ```
      Comments.model.onSave(model)
      ```
      ###
      onSave: -> @clean().updateHotness()


      onCreated: ->
        #! Save the model in elasticsearch!
        Elasticsearch.create "comments", @id,
          id: @id
          content: @get "content"
          created_at: @get "created_at"
          created_by: @get "created_by"
          created_by_uname: @get "created_by_uname"
          slug: @get "slug"
          meta: @get "meta"
          votes_count: 1


      onUpdated: ->
        Elasticsearch.update "comments", @id,
          content: @get "content"
          votes_count: @get "votes_count"


Model["@require"] = [
  "libraries/elasticsearch"
  "models/base/model"
  "models/news/stories"
  "models/news/votes"
]
Model["@singleton"] = true
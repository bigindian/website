# # News Story Model
#
# This model represents a news story. It is main model through which stories are
# created, upvoted, moderated and rated.
Promise   = require "bluebird"
validator = require "validator"
markdown  = require("markdown").markdown


Model = (BaseModel, Comments, NewsCategories, NewsVotes, Users) ->
  # **MAX_EDIT_MINS** After this many minutes, a story cannot be edited.
  MAX_EDIT_MINS = 90


  # **RECENT_DAYS** Days a story is considered recent, for resubmitting
  RECENT_DAYS = 30


  # **ACTIVITY_WEIGHT** Amount that any activity inside of the story gets.
  ACTIVITY_WEIGHT = 2


  # **CREATION_WINDOW** The window variable is used narrow down how effective the creation date is
  # when the post's hotness is calculated. A smaller window allows lesser
  # activity before the post makes it to the front page. A bigger window allows
  # more room for old stories to become popular with comments.
  #
  #! As the site grows, you might want to shrink this down to 12 or so.
  CREATION_WINDOW = 60 * 60 * 60.0


  new class Stories extends BaseModel
    tableName: "news_stories"

    enums: categories: tableName: "news_categories"


    extends:
      categories: -> @hasMany "news_story_category", "story"
      comments: -> @hasMany "news_comments", "story"
      created_by: -> @belongsTo "users", "created_by"
      updated_by: -> @belongsTo "users", "updated_by"


      ###
      **getScore()** Helper function to calculate the score. The score should only be a
      function of the upvotes and downvotes.

      ```
      Stories.model.getScore() # -> 30
      ```
      ###
      getScore: -> (@get("upvotes") - @get("downvotes")) or 0


      ###
      **getCommentScore()** gets the score of the comments with the current
       model's story id. This function will have to query the DB to calculate
       the score hence will return a promise

      ```
      Stories.model.getCommentScore() # -> Promise.resolve(123)
      ```
      ###
      getCommentScore: -> 0


      ###
      **updateHotness()** Calculates and updates the hotness of the current
      story. This function can be chained with other bookshelf functions.

      ```
      Stories.model.updateHotness.save()
      ```
      ###
      updateHotness: ->
        createdDate = Number new Date(@get "created_at").getTime() or Date.now()
        score = @getScore()

        #! Give a story's comment votes some weight.
        cpoints = @getCommentScore()

        #! Don't immediately kill stories at 0 by bumping up score by one
        activityScore = (Math.abs(score + 1) + cpoints) * ACTIVITY_WEIGHT

        #! Now using the log function is really nice because it evens out
        #! activity after a bunch of comments.
        activityPoints = Math.log Math.max(activityScore, 1), 10

        #! Now with the acitvityPoints set, decide if the post should be punished
        #! or rewared by the score of it (ie a function of the upvotes and
        #! downvotes).
        if score > 0 then rewardOrPunish = 1
        else if score < 0 then rewardOrPunish = -1
        else rewardOrPunish = 0

        #! Recalculate the activity points based on the score.
        activityPoints = activityPoints * rewardOrPunish

        #! The creation points is set so that newer posts get more hotness than
        #! older ones. The window variable is used narrow down how effectiv
        #! already trending ones.
        creationPoints = createdDate / CREATION_WINDOW

        #! The final hotness is simply the sum of all the different points.
        hotness = activityPoints + creationPoints

        #! Round off the hotness so that postgres stays happy and set it to the
        #! model!
        #! See http://stackoverflow.com/questions/11832914/round-to-at-most-2-decimal-places-in-javascript
        @set "hotness", Math.round(hotness * 10 * 7)/(10 * 7)

        #! Return this instance to allow chaining.
        this


      ###
      **increaseCommentsCount()** Increases the number of comments for the given
      story. Use this function only when a new comment has been added into the
      story.

      ```
      Stories.model.increaseCommentsCount.then (model) ->
      ```
      ###
      increaseCommentsCount: ->
        @set "comments_count", 1 + @get "comments_count"
        @updateHotness().save()


      ###
      **upvote()** Up-votes the story with the given id. Requires the id of
      the user who is voting also.

      ```
      userid = request.user.id
      Stories.model.upvote(userid).then (model) ->
      ```
      ###
      upvote: (user_id) ->
        #! Try to add the vote into the votes table
        NewsVotes.create
          is_upvote: true
          story: @id
          user: user_id

        #! If the upvote could be added properly then we save the model!
        .then =>
          #! Update the hotness and the upvotes counter
          @set "upvotes", 1 + @get "upvotes"
          @updateHotness()
          @save()


      ###
      **isRecent()** Returns true iff the story was created recently.

      ```
      Stories.model.isRecent() # True/False
      ```
      ###
      isRecent: -> @created_at >= RECENT_DAYS #.days.ago # fix this


    ###
    **top()** Returns the top stories. Works similar to the query function


    ```
    Stories.top(buildQueryFn, {}).then (storyCollection) ->
    ```
    ###
    top: (buildQuery, options={}) ->
      options.order = hotness: "DESC"
      options.withRelated = ["created_by", "categories"]
      @query buildQuery, options


    ###
    **create()** Creates a new Story with the given pramaters.

    ```
    parameters =
      created_by: 123
      title: "title goes here"
      url: "http://link"

    Stories.create({}).then (model) ->
    ```
    ###
    create: (parameters) ->
      categories = parameters.categories or []

      delete parameters.categories

      #! First set the slug from the right variable.
      parameters.slug = @createSlug parameters.title

      #! Then parse the description!
      if description = parameters.description
        parameters.description = markdown.toHTML description

      #! Now create the model and save it into the DB
      @model.forge(parameters).save()
      .then (model) =>
        #! For each category that was set in the parameters prepare the values
        #! for the insert query.
        insertQuery = (category: cat, story: model.id for cat in categories)

        #! Simultaneously update the hotness and the add the categories!
        Promise.all([
          model.updateHotness().save()
          @knex("news_story_category").insert insertQuery
        ]).then -> model


    ###
    **recent()** Returns a collection of recent stories.

    ```
    Stories.recent().then (storyCollection) ->
    ```
    ###
    recent: (buildQuery, options={}) ->
      options.withRelated = ["created_by", "categories"]
      options.order = created_at: "DESC"
      @model.forge().fetchPage buildQuery, options


    ###
    **comments()** Returns the comments for the story with the given id.

    ```
    Stories.comments(0).then (commentsCollection) ->
    ```
    ###
    comments: (id) ->
      @model.where(id: id).fetch withRelated: ["comments"]
      .then (story) -> story.related("comments").load "created_by"


    ###
    **increaseCommentsCount()** Increases the number of comments for the given
    story. Use this function only when a new comment has been added into the
    story.

    ```
    Stories.increaseCommentsCount(1).then (model) ->
    ```
    ###
    increaseCommentsCount: (id) ->
      @get(id).then (model) ->
        model.set "comments_count", 1 + model.get "comments_count"
        model.updateHotness()


Model["@singleton"] = true
Model["@require"] = [
  "models/base/model"
  "models/comments"
  "models/news/categories"
  "models/news/votes"
  "models/users"
]
module.exports = Model
# # News Story Model
#
# This model represents a news story. It is main model through which stories are
# created, upvoted, moderated and rated.

###
  @apiDefine StoryModelResponse

  @apiSuccess {Number} id the id of the story
  @apiSuccess {String} domain the domain of the link
  @apiSuccess {String} domain the domain of the link
  @apiSuccess {String} description the HTML description by the author
  @apiSuccess {String} description_markdown the Markdown (raw) description by the author
  @apiSuccess {String} slug the url slug for the story.
  @apiSuccess {Number} upvotes the number of upvotes
  @apiSuccess {Number} downvotes the number of downvotes
  @apiSuccess {Number} comments_count the number of comments
  @apiSuccess {Number} hotness the hotness (ranking) of the story
  @apiSuccess {Boolean} is_expired true if the story has expired
  @apiSuccess {Boolean} is_moderated true if the story has been moderated
  @apiSuccess {Object} meta any optional meta attributes for the story
  @apiSuccess {Number} created_by id of the user who created this story
  @apiSuccess {Number} updated_by id of the user who last updated this story
  @apiSuccess {Number} created_at date when this story was created
  @apiSuccess {Number} updated_at date when this story was last updated
  @apiSuccessExample {json} Success-Response:
    {
      "id": 1,
      "title": "This is a sample link",
      "domain": "github.com",
      "description": "This is sometings cool",
      "description_markdown": "<p>This is sometings cool</p>",
      "slug": "this-is-something-1",
      "url": "https://github.com/enamakel/thebigindian.news",
      "upvotes": 0,
      "downvotes": 0,
      "comments_count": 1,
      "hotness": "-11088.4732896000",
      "is_expired": false,
      "is_moderated": true,
      "merged_story": 1,
      "story_cache": "",
      "meta": {},
      "created_by": 1,
      "updated_by": null,
      "created_at": "2015-09-13T09:46:45.811Z",
      "updated_at": "2015-09-13T09:46:45.811Z"
    }
###
Promise   = require "bluebird"
validator = require "validator"
markdown  = require("markdown").markdown
url       = require "url"


Model = (Elasticsearch, BaseModel, Comments, NewsVotes, Users) ->
  # **MAX_EDIT_MINS** After this many minutes, a story cannot be edited.
  MAX_EDIT_MINS = 90


  # **RECENT_DAYS** Days a story is considered recent, for resubmitting
  RECENT_DAYS = 30


  # **ACTIVITY_WEIGHT** Amount that any activity inside of the story gets.
  ACTIVITY_WEIGHT = 2


  # **CREATION_WINDOW** The window variable is used narrow down how effective
  # the creation date is when the post's hotness is calculated. A smaller window
  # allows lesser activity before the post makes it to the front page. A bigger
  # window allows more room for old stories to become popular with comments and
  # upvotes.
  #
  #! As the site grows, you might want to shrink this down to 12 or so.
  CREATION_WINDOW = 60 * 60 * 60.0


  new class Stories extends BaseModel
    tableName: "news_stories"


    # Properties to extend to the model!
    extends:
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

        #! Don't immediately kill stories at 0. bump them up by one
        if score is 0 then score += 1

        #! Calculate the activity's score
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
        #! already trending ones will take the top spot.
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
        @save()


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
          @save()


      ###
      **isRecent()** Returns true iff the story was created recently.

      ```
      Stories.model.isRecent() # True/False
      ```
      ###
      isRecent: -> @created_at >= RECENT_DAYS #.days.ago # fix this


      ###
      **onSave()** Update the hotness of the story every time it gets saved into
      the DB.

      ```
      Story.model.onSave(model)
      ```
      ###
      onSave: ->
        @clean()
        @updateHotness()


      onCreate: -> return


      onCreated: ->
        #! Save the model in elasticsearch!
        Elasticsearch.create "stories", @id,
          comments_count: @get "comments_count"
          created_at: @get "created_at"
          created_by: @get "created_by"
          content: @get "description"
          domain: @get "domain"
          hotness: @get "hotness"
          title: @get "title"
          url: @get "url"



    ###
    **top()** Returns the top stories. Works similar to the query function

    ```
    Stories.top(buildQueryFn, {}).then (storyCollection) ->
    ```
    ###
    top: (buildQuery, options={}) ->
      options.order = hotness: "DESC"
      options.withRelated = ["created_by"]
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
      parameters.domain = url.parse(parameters.url).hostname

      #! First set the slug from the right variable.
      parameters.slug = @createSlug()

      #! Then parse the description!
      if description = parameters.description
        parameters.description = markdown.toHTML description

      #! Now create the model and save it into the DB
      @model.forge(parameters).save()


    ###
    **recent()** Returns a collection of recent stories.

    ```
    Stories.recent().then (storyCollection) ->
    ```
    ###
    recent: (buildQuery, options={}) ->
      options.withRelated = ["created_by"]
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



Model["@singleton"] = true
Model["@require"] = [
  "libraries/elasticsearch"
  "models/base/model"
  "models/comments"
  "models/news/votes"
  "models/users"
]
module.exports = Model
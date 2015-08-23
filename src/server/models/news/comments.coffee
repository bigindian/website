markdown = require("markdown").markdown


exports = module.exports = (NotFoundError, BaseModel, NewsStories, NewsVotes) ->
  class Model extends BaseModel
    tableName: "news_comments"

    create: (storyID, data) ->
      #! First find the story for which we are adding the comment
      NewsStories.get(storyID).then (story) =>
        #! If the story was not found then throw a 404
        if not story? then throw new NotFoundError

        #! Prepare the strucutre of the new comment
        newComment =
          content_markdown: data.content
          content: markdown.toHTML data.content
          created_by: data.created_by
          story: storyID
          slug: @createSlug()

        #! Create the new comment!
        @model.forge(newComment).save()

        #! If successful then increment the comments count for the given story.
        .then (comment) -> story.increaseCommentsCount()



    extends:
      created_by: -> @belongsTo "users", "created_by"


      upvote: (user_id) ->
        #! Try to add the vote into the votes table
        NewsVotes.create
          is_upvote: true
          comment: @id
          user: user_id

        #! If the upvote could be added properly then we save the model!
        .then =>
          #! Update the hotness and the upvotes counter
          @set "upvotes", 1 + @get "upvotes"
          # @updateHotness()
          @save()




  new Model


exports["@require"] = [
  "libraries/errors/NotFoundError"
  "models/base/model"
  "models/news/stories"
  "models/news/votes"
]
exports["@singleton"] = true
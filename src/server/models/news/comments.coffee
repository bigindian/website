markdown = require("markdown").markdown


exports = module.exports = (BaseModel, Stories) ->
  class Model extends BaseModel
    tableName: "news_comments"

    create: (storyID, data) ->
      # First prepare the strucutre of the new comment
      newComment =
        content_markdown: data.content
        content: markdown.toHTML data.content
        created_by: data.created_by
        story: storyID
        slug: @createSlug()

      # Create the new comment!
      @model.forge(newComment).save()

      # If successful then increment the comments count for the given story.
      .then (comment) -> Stories.increaseCommentsCount storyID


    extends:
      created_by: -> @belongsTo "users", "created_by"
      hasTimestamps: false


  new Model


exports["@require"] = [
  "models/base/model"
  "models/news/stories"
]
exports["@singleton"] = true
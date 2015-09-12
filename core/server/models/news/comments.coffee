markdown = require("markdown").markdown


exports = module.exports = (Elasticsearch, BaseModel, NewsStories, NewsVotes) ->
  new class Model extends BaseModel
    tableName: "news_comments"

    create: (storyID, data) ->
      #! First find the story for which we are adding the comment
      NewsStories.get(storyID).then (story) =>
        #! Prepare the strucutre of the new comment
        newComment =
          content_markdown: data.content
          content: markdown.toHTML data.content
          created_by: data.created_by
          parent: data.parent
          story: storyID
          slug: @createSlug()

        #! Create the new comment!
        @model.forge(newComment).save()

        #! If successful then
        .then (model) ->
          promise = Elasticsearch.create "comments", model.id,
            content: model.get "content_markdown"
            created_at: model.get "created_at"
            created_by: model.get "created_by"
            hotness: model.get "hotness"
            title: model.get "title"

          #! increment the comments count for the given story.
          story.increaseCommentsCount()

          return model


    createChild: (id, data) ->
      #! Add the parent comment's id in the body
      data.parent = id

      #! Then fetch the parent and then create the child!
      @get(id).then (parentComment) => @create(parentComment.get("story"), data)



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
          is_upvote: true
          user: user_id

        #! If the upvote could be added properly then we save the model!
        .then =>
          #! Update the hotness and the upvotes counter
          @set "upvotes", 1 + @get "upvotes"
          # @updateHotness()
          @save()


exports["@require"] = [
  "libraries/elasticsearch"
  "models/base/model"
  "models/news/stories"
  "models/news/votes"
]
exports["@singleton"] = true
exports = module.exports = (Stories, Comments) ->
  routes: ["/story/([a-z0-9\-]+)"]


  controller: (request, response, next) ->
    data = {}

    slug = request.params[0]
    console.log slug

    # First get the story by the slug
    Stories.getBySlug slug, withRelated: ["created_by", "categories", "comments"]
    .then (story) ->
      # Load the comments now
      story.related("comments").load "created_by"
      .then (comments) ->
        comments = comments.toJSON()
        story.set "comments", comments
        story

    # Once the comments have been loaded too, start rendering the page
    .then (story) ->
      story = story.toJSON()

      response.render "main/news/single",
        title: story.title
        metaRobots: "nofollow"
        data:
          noFollow: true
          story: story


    .catch (e) -> next e


exports["@require"] = [
  "models/news/stories"
  "models/news/comments"
]
exports["@singleton"] = true
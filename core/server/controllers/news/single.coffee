Controller = module.exports = (Stories, Comments) ->
  (request, response, next) ->
    data = {}

    slug = request.params.slug

    # First get the story by the slug
    Stories.getBySlug slug, withRelated: ["created_by", "comments"]
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


Controller["@require"] = [
  "models/news/stories"
  "models/news/comments"
]
Controller["@routes"] = ["/story/:slug"]
Controller["@singleton"] = true
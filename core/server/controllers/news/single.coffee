Controller = module.exports = (Stories, Comments) ->
  (request, response, next) ->
    data = {}

    slug = request.params.slug

    # First get the story by the slug
    Stories.getBySlug slug, withRelated: ["comments"]

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
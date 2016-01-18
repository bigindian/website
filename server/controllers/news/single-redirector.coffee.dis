Controller = module.exports = (Stories) ->
  (request, response, next) ->
    slug = request.params.slug

    Stories.getBySlug slug
    .then (story) ->
      # Register user's interest here...

      # Redirect to the story.
      response.redirect story.get "url"

    .catch (e) -> next e


Controller["@require"] = ["models/news/stories"]
Controller["@routes"] = [
  "/story/:slug/redirect"
  "/story/:slug/open"
]
Controller["@singleton"] = true
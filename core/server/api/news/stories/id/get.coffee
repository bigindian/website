Controller = module.exports = (Stories) ->
  (request, response, next) ->
    Stories.get request.params.id
    .then (story) -> response.json story
    .catch ->
      response.status 404
      response.json {}


Controller["@require"] = ["models/news/stories"]
Controller["@routes"] = ["/news/stories/:id"]
Controller["@singleton"] = true
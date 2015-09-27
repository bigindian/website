Controller = module.exports = (Stories) ->
  (request, response, next) ->
    Stories.get request.params[0]
    .then (story) -> response.json story
    .catch ->
      response.status 404
      response.json {}


Controller["@require"] = ["models/news/stories"]
Controller["@singleton"] = true
Controller["@routes"] = ["/news/stories/([0-9]+)"]
exports = module.exports = (Stories) ->
  routes: ["/news/stories/([0-9]+)"]

  controller: (request, response, next) ->
    Stories.get request.params[0]
    .then (story) -> response.json story
    .catch ->
      response.status 404
      response.json {}


exports["@require"] = ["models/news/stories"]
exports["@singleton"] = true
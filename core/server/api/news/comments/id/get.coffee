Controller = module.exports = (Comments) ->
  (request, response, next) ->
    Comments.get request.params[0]
    .then (comment) -> response.json comment
    .catch ->
      response.status 404
      response.json {}


Controller["@require"] = ["models/news/comments"]
Controller["@routes"] = ["/news/comments/([0-9]+)"]
Controller["@singleton"] = true
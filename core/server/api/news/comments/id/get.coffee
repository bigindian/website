Controller = module.exports = (Comments) ->
  (request, response, next) ->
    Comments.get request.params.id
    .then (comment) -> response.json comment
    .catch ->
      response.status 404
      response.json {}


Controller["@require"] = ["models/news/comments"]
Controller["@routes"] = ["/news/comments/:id"]
Controller["@singleton"] = true
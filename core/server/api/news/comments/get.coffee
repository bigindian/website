Controller = module.exports = (Comments) ->
  (request, response, next) ->
    Comments.query(null, page: request.query.page)
    .then (comments) -> response.json comments
    .catch ->
      response.status 404
      response.json "no comments"


Controller["@require"] = ["models/news/comments"]
Controller["@routes"] = ["/news/comments"]
Controller["@singleton"] = true
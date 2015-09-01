exports = module.exports = (Comments) ->
  routes: ["/news/comments"]

  controller: (request, response, next) ->
    Comments.query(null, page: request.query.page)
    .then (comments) -> response.json comments
    .catch ->
      response.status 404
      response.json "no comments"


exports["@require"] = ["models/news/comments"]
exports["@singleton"] = true
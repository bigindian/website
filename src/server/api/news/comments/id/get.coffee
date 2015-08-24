exports = module.exports = (Comments) ->
  routes: ["/news/comments/([0-9]+)"]

  controller: (request, response, next) ->
    Comments.get request.params[0]
    .then (comment) -> response.json comment
    .catch ->
      response.status 404
      response.json {}


exports["@require"] = ["models/news/comments"]
exports["@singleton"] = true
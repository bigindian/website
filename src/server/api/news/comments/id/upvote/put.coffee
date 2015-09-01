exports = module.exports = (Comments) ->
  routes: ["/news/comments/([0-9]+)/upvote"]

  controller: (request, response, next) ->
    Comments.get request.params[0]
    .then (comment) -> comment.upvote request.user.id
    .then -> response.json "voted"
    .catch (e) -> next e


exports["@require"] = ["models/news/comments"]
exports["@singleton"] = true
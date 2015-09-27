Controller = module.exports = (Comments) ->
  (request, response, next) ->
    Comments.get request.params.comment
    .then (comment) -> comment.upvote request.user.id
    .then -> response.json "voted"
    .catch (e) -> next e


Controller["@middlewares"] = ["CheckForLogin"]
Controller["@require"] = ["models/news/comments"]
Controller["@routes"] = ["/news/comments/:comment/upvote"]
Controller["@singleton"] = true
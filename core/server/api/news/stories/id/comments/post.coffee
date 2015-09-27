Controller = module.exports = (Story, Comments) ->
  (request, response, next) ->
    request.body.created_by = request.user.id

    Comments.create request.params.story, request.body
    .then (comment) -> response.json comment
    .catch (e) -> next e


Controller["@middlewares"] = ["CheckForLogin", "CheckCaptcha"]
Controller["@require"] = [
  "models/news/stories"
  "models/news/comments"
]
Controller["@routes"] = ["/news/stories/:story/comments"]
Controller["@singleton"] = true
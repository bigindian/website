Controller = module.exports = (Comments) ->
  (request, response, next) ->
    request.body.created_by = request.user.id

    #! Now create the comment!
    Comments.createChild request.params.id, request.body
    .then (comment) -> response.json comment
    .catch (e) -> next e


Controller["@middlewares"] = ["CheckForLogin", "CheckCaptcha"]
Controller["@require"] = ["models/news/comments"]
Controller["@routes"] = ["/news/comments/:id/children"]
Controller["@singleton"] = true
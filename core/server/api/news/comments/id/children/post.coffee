exports = module.exports = (reCaptcha, Story, Comments) ->
  routes: ["/news/comments/([0-9]+)/children"]

  controller: (request, response, next) ->
    reCaptcha.verify(request).then ->
      request.body.created_by = request.user.id

      #! Now create the comment!
      Comments.createChild request.params[0], request.body
    .then (comment) -> response.json comment
    .catch (e) -> next e


exports["@require"] = [
  "libraries/recaptcha"
  "models/news/stories"
  "models/news/comments"
]
exports["@singleton"] = true
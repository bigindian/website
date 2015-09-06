exports = module.exports = (reCaptcha, Story, Comments) ->
  routes: ["/news/comments/([0-9]+)/children"]

  controller: (request, response, next) ->
    Comments.findByParent request.params[0]
    .then (comments) -> response.json comments
    .catch (e) -> next e


exports["@require"] = [
  "libraries/recaptcha"
  "models/news/stories"
  "models/news/comments"
]
exports["@singleton"] = true
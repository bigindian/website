exports = module.exports = (reCaptcha, Story, Comments) ->
  routes: ["/news/stories/([0-9]+)/comments"]

  controller: (request, response, next) ->
    request.body.created_by = request.user.id

    reCaptcha.verify request
    .then -> Comments.create request.params[0], request.body
    .then (comment) -> response.json comment
    .catch (e) -> next e


exports["@require"] = [
  "libraries/recaptcha"
  "models/news/stories"
  "models/news/comments"
]
exports["@singleton"] = true
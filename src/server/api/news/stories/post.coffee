exports = module.exports = (NeedAuthError, reCaptcha, Stories) ->
  routes: ["/news/stories"]
  controller: (request, response, next) ->
    if not request.isAuthenticated() then return next new NeedAuthError

    request.body.created_by = request.user.id

    reCaptcha.verify request
    .then -> Stories.create request.body
    .then (story) -> response.json story
    .catch (e) -> next e


exports["@require"] = [
  "libraries/errors/NeedAuthenticationError"
  "libraries/recaptcha"
  "models/news/stories"
]
exports["@singleton"] = true
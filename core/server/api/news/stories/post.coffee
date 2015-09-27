Controller = module.exports = (Stories) ->
  (request, response, next) ->
    request.body.created_by = request.user.id

    Stories.create request.body
    .then (story) -> response.json story
    .catch (e) -> next e


Controller["@middlewares"] = ["CheckForLogin", "CheckCaptcha"]
Controller["@require"] = ["models/news/stories"]
Controller["@routes"] = ["/news/stories"]
Controller["@singleton"] = true
Controller = module.exports = (Stories) ->
  (request, response, next) ->
    Stories.get request.params[0]
    .then (model) -> model.upvote request.user.id
    .then -> response.json "voted"
    .catch (e) -> response.json "already voted"


Controller["@middlewares"] = ["CheckForLogin"]
Controller["@require"] = ["models/news/stories"]
Controller["@singleton"] = true
Controller["@routes"] = ["/news/stories/([0-9]+)/upvote"]
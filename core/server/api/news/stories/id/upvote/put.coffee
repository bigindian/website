Controller = module.exports = (Stories) ->
  (request, response, next) ->
    Stories.get request.params.story
    .then (model) -> model.upvote request.user.id
    .then -> response.json "voted"
    .catch (e) -> response.json "already voted"


Controller["@middlewares"] = ["CheckForLogin"]
Controller["@require"] = ["models/news/stories"]
Controller["@routes"] = ["/news/stories/:story/upvote"]
Controller["@singleton"] = true
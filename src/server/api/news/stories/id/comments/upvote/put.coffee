exports = module.exports = (Stories) ->
  routes: ["/news/stories/([0-9]+)/comments/upvote"]

  controller = (request, response, next) ->
    Stories.get request.params[0]
    .then (model) -> model.upvote request.user.id
    .then -> response.json "voted"
    .catch (e) -> response.json "already voted"


exports["@require"] = ["models/news/stories"]
exports["@singleton"] = true
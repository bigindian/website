Controller = module.exports = (Stories) ->
  (request, response, next) ->
    Stories.query().then (stories) ->  response.json stories
    .catch ->
      response.status 404
      response.json "no stories"


Controller["@require"] = ["models/news/stories"]
Controller["@singleton"] = true
Controller["@routes"] = ["/news"]
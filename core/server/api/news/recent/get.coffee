Controller = module.exports = (Stories) ->
  (request, response, next) ->
    Stories.recent().then (stories) ->  response.json stories
    .catch (e) ->
      console.trace e
      response.status 404
      response.json "no top stories"


Controller["@require"] = ["models/news/stories"]
Controller["@routes"] = ["/news/recent"]
Controller["@singleton"] = true
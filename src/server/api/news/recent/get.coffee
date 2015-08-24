exports = module.exports = (Stories) ->
  routes: ["/news/recent"]

  controller = (request, response, next) ->
    Stories.recent().then (stories) ->  response.json stories
    .catch (e) ->
      console.trace e
      response.status 404
      response.json "no top stories"


exports["@require"] = ["models/news/stories"]
exports["@singleton"] = true

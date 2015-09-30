Controller = module.exports = (Stories) ->
  (request, response, next) ->
    Stories.recent(null, page: request.params[0] or 1).then (stories) ->
      response.render "main/news/recent",
        metaRobots: "noarchive"
        cache:
          enable: true
          timeout: 60 * 1 # 1 minute cache
        data: stories
        title: null

    .catch (e) -> next e


Controller["@require"] = ["models/news/stories"]
Controller["@routes"] = [
  "/recent"
  "/recent/page/([0-9]+)"
]
Controller["@singleton"] = true
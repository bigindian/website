exports = module.exports = (Stories) ->
  routes: [
    "/recent"
    "/recent/page/([0-9]+)"
  ]

  controller: (request, response, next) ->
    Stories.recent(null, page: request.params[0] or 1).then (stories) ->
      response.render "main/news/recent",
        metaRobots: "noarchive"
        cache:
          enable: true
          timeout: 60 * 1 # 1 minute cache
        data: stories
        title: null

    .catch (e) -> next e


exports["@require"] = ["models/news/stories"]
exports["@singleton"] = true
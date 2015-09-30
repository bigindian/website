exports = module.exports = (Cache, Stories) ->
  routes: [
    ""
    "/page/([0-9]+)?"
  ]

  controller: (request, response, next) ->
    page = request.params[0] or 1
    cacheKey = "main/news/index/#{page}"

    Cache.get cacheKey
    .catch ->
      # console.log request.params[0]
      Stories.top null, page: page
      .then (stories) ->

        json = JSON.stringify stories

        #! Cache only the first three pages!
        if 0 <= page and page >= 3 then Cache.set cacheKey, json, 60 * 1
        else json


    .then (stories) ->
      response.render "main/news/index",
        # cache:
          # enable: true
          # timeout: 60 * 1 # 1 minute cache
        data: JSON.parse stories
        metaRobots: "noarchive"
        title: null

    .catch (e) -> next e


exports["@require"] = [
  "libraries/cache"
  "models/news/stories"
]
exports["@singleton"] = true
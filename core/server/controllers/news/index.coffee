Controller = module.exports = (Cache, Stories) ->
  (request, response, next) ->
    page = request.params[0] or 1
    cacheKey = "main/news/index/#{page}"

    Cache.get cacheKey
    .catch ->
      Stories.top null, page: page
      .then (results) ->

        json = JSON.stringify results

        #! Cache only the first three pages!
        if 0 <= page and page >= 3 then Cache.set cacheKey, json, 60 * 1
        else json


    .then (results) ->
      response.render "main/news/index",
        # cache:
          # enable: true
          # timeout: 60 * 1 # 1 minute cache
        data: JSON.parse results
        metaRobots: "noarchive"
        title: null

    .catch (e) -> next e


Controller["@require"] = [
  "libraries/cache"
  "models/news/stories"
]
Controller["@routes"] = [
  ""
  "/page/([0-9]+)?"
]
Controller["@singleton"] = true
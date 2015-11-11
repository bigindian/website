Controller = module.exports = (Cache, Stories) ->
  (request, response, next) ->
    page = request.params.page or 1
    cacheKey = "main/news/recent/#{page}"

    Cache.get cacheKey
    .catch ->
      Stories.recent null, page: page
      .then (results) ->

        json = JSON.stringify results

        #! Cache only the first fifty pages!
        if 0 <= page and page >= 50 then Cache.set cacheKey, json, 60 * 1 # 1 minute cache
        else json


    .then (results) ->
      response.render "main/news/recent",
        data: JSON.parse results
        metaRobots: "noarchive"


    .catch (e) -> next e


Controller["@require"] = [
  "libraries/cache"
  "models/news/stories"
]
Controller["@routes"] = [
  "/recent"
  "/recent/page/:page"
]
Controller["@singleton"] = true
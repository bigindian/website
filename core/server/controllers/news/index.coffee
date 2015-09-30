Controller = module.exports = (Cache, Stories) ->
  (request, response, next) ->
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


Controller["@require"] = [
  "libraries/cache"
  "models/news/stories"
]
Controller["@routes"] = [
  ""
  "/page/([0-9]+)?"
]
Controller["@singleton"] = true
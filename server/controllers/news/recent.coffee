Controller = module.exports = (Cache, Story) ->
  (request, response, next) ->
    page = request.params.page or 1
    cacheKey = "main/news/index/#{page}"


    options =
      offset: 0
      limit: 10
      sort: created_at: -1

    Story.paginate {}, options
    .then (results) ->
      response.render "main/news/index",
        data: results
        metaRobots: "noarchive"
        title: null


Controller["@require"] = [
  "libraries/cache"
  "models/news/story"
]
Controller["@routes"] = [
  "/recent"
  "/recent/page/:page"
]
Controller["@singleton"] = true
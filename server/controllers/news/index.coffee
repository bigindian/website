Controller = module.exports = (Cache, Story) ->
  (request, response, next) ->
    page = request.params.page or 1
    cacheKey = "main/news/index/#{page}"

    options =
      offset: 10 * request.params.page
      limit: 10
      sort: hotness: -1

    Story.paginate is_banned: false, options
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
  ""
  "/page/:page"
]
Controller["@singleton"] = true
Controller = module.exports = (Cache, Story) ->
  (request, response, next) ->
    page = request.params.page or 1
    cacheKey = "main/news/index/#{page}"


    Story
    .find()
    .sort "-hotness"
    .limit 15
    .exec()
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
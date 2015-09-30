Controller = module.exports = (Stories) ->
  (request, response, next) ->
    Stories.recent null, page: request.params.page or 1
    .then (results) ->
      response.render "main/news/recent",
        metaRobots: "noarchive"
        cache:
          enable: true
          timeout: 60 * 1 # 1 minute cache
        data:
          collection: results.collection.toJSON()
          pagination: results.pagination
        title: null

    .catch (e) -> next e


Controller["@require"] = ["models/news/stories"]
Controller["@routes"] = [
  "/recent"
  "/recent/page/:page"
]
Controller["@singleton"] = true
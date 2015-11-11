Controller = module.exports = (Comments) ->
  (request, response, next) ->
    Comments.recent null, page: request.params.page or 1
    .then (results) ->
      response.render "main/news/comments",
        metaRobots: "noarchive"
        cache:
          enable: true
          timeout: 60 * 1 # 1 minute cache
        data:
          collection: results.collection.toJSON()
          pagination: results.pagination
        title: null

    .catch (e) -> next e


Controller["@require"] = ["models/news/comments"]
Controller["@routes"] = [
  "/comments"
  "/comments/page/:page"
]
Controller["@singleton"] = true
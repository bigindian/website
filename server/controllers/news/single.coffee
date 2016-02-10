Controller = module.exports = (Story) ->
  (request, response, next) ->
    Story.findOne _id: request.params.id
    .then (result) ->
      response.render "main/news/single",
        data: story: result
        metaRobots: "noarchive"
        title: null


Controller["@require"] = ["models/news/story"]
Controller["@routes"] = [
  "/story/:id"
  "/story/:id/:slug"
]
Controller["@singleton"] = true
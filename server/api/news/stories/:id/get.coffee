Controller = module.exports = (Story) ->
  (request, response, next) ->
    Story.findOne _id: request.params.id
    .then (result) -> response.json result


Controller["@require"] = ["models/news/story"]
Controller["@routes"] = ["/news/stories/:id"]
Controller["@singleton"] = true
Controller = module.exports = (Story) ->
  (request, response, next) ->
    Story.findOne _id: request.params.id
    .then (story) ->
      story.remove()
      response.json story



Controller["@require"] = ["models/news/story"]
Controller["@routes"] = ["/news/stories/:id"]
Controller["@singleton"] = true
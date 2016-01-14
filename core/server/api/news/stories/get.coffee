Controller = module.exports = (Story) ->
  (request, response, next) ->
    Story.find().exec()
    .then (results) -> response.json results


Controller["@require"] = ["models/news/story"]
Controller["@routes"] = ["/news/stories"]
Controller["@singleton"] = true
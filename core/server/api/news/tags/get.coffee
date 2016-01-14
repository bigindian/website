Controller = module.exports = (Story) ->
  (request, response, next) ->
    response.json []


Controller["@require"] = ["models/news/story"]
Controller["@routes"] = ["/news/tags"]
Controller["@singleton"] = true
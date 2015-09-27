Controller = module.exports = (Stories) ->
  (request, response, next) -> response.json Stories.categories


Controller["@require"] = ["models/news/stories"]
Controller["@routes"] = ["/news/categories"]
Controller["@singleton"] = true
Controller = module.exports = (Stories) ->
  (request, response, next) -> response.json Stories.categories


Controller["@require"] = ["models/news/stories"]
Controller["@singleton"] = true
Controller["@routes"] = ["/news/categories"]
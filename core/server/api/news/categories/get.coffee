Controller = module.exports = (Feed) ->
  (request, response, next) -> response.json Feed.categories


Controller["@require"] = ["models/news/feed"]
Controller["@routes"] = ["/news/categories"]
Controller["@singleton"] = true
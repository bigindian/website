Controller = module.exports = (Stories) ->
  (request, response, next) -> response.json {}


Controller["@require"] = ["models/news/stories"]
Controller["@singleton"] = true
Controller["@routes"] = ["/news/moderations"]
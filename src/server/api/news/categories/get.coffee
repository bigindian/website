exports = module.exports = (Stories) ->
  controller = (request, response, next) -> response.json Stories.categories


exports["@require"] = ["models/news/stories"]
exports["@singleton"] = true
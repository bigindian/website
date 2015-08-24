exports = module.exports = (Stories) ->
  routes: ["/news/categories"]
  controller: (request, response, next) -> response.json Stories.categories


exports["@require"] = ["models/news/stories"]
exports["@singleton"] = true
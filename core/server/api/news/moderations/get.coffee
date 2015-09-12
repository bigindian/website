exports = module.exports = (Stories) ->
  routes: ["/news/moderations"]

  controller: (request, response, next) ->
    response.json {}


exports["@require"] = ["models/news/stories"]
exports["@singleton"] = true
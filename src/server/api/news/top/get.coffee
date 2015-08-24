exports = module.exports = (Stories) ->
  routes: ["/news/top"]
  controller: (request, response, next) ->

    # CHECK FOR sqlinjection
    Stories.top(null, page: request.query.page)
    .then (stories) -> response.json stories
    .catch (e) -> next e


exports["@require"] = ["models/news/stories"]
exports["@singleton"] = true
Controller = module.exports = (Stories) ->
  (request, response, next) ->
    url = decodeURIComponent request.query.u or ""

    Stories.fetchInformation url
    .then (results) -> response.json results
    .catch (error) -> next error


Controller["@middlewares"] = ["EnsureLoggedIn"]
Controller["@require"] = ["models/news/stories"]
Controller["@routes"] = ["/news/scrape"]
Controller["@singleton"] = true
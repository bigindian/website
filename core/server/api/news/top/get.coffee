Controller = module.exports = (Stories) ->
  (request, response, next) ->

    # CHECK FOR sqlinjection
    Stories.top null, page: request.query.page
    .then (stories) -> response.json stories
    .catch (e) -> next e


# Controller["@require"] = ["models/news/stories"]
Controller["@routes"] = ["/news/top"]
Controller["@singleton"] = true
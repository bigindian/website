Controller = module.exports = (Feed) ->
  (request, response, next) ->
    Feed.query().then (feeds) ->  response.json feeds
    .catch (e) -> next e


Controller["@require"] = ["models/news/feed"]
Controller["@routes"] = ["/news/feed"]
Controller["@singleton"] = true
Controller = module.exports = (Feed) ->
  (request, response, next) ->
    Feed.forge(id: request.params.id)
    .fetch().then (story) -> response.json story
    .catch (e) -> next e


Controller["@require"] = ["models/news/feed"]
Controller["@routes"] = ["/news/feeds/:id"]
Controller["@singleton"] = true
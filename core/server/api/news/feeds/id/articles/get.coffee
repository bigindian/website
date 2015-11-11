Controller = module.exports = (Articles) ->
  (request, response, next) ->
    Articles.forge feed: request.params.id
    .fetchPage().then (collection) -> response.json collection
    .catch (e) -> next e


Controller["@require"] = ["models/news/article"]
Controller["@routes"] = ["/news/feeds/:id/articles"]
Controller["@singleton"] = true
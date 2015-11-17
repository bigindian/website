Controller = module.exports = (Articles) ->
  (request, response, next) ->
    Articles.forge() #feed: request.params.id
    .query (qb) ->
      qb.orderBy "published_at", "desc"
      qb.where "feed", request.params.id
      qb.limit 10
    .fetchAll().then (collection) -> response.json collection
    .catch (e) -> next e


Controller["@require"] = ["models/news/article"]
Controller["@routes"] = ["/news/feeds/:id/articles"]
Controller["@singleton"] = true
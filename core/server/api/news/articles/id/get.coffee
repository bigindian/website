Controller = module.exports = (Article) ->
  (request, response, next) ->
    Article.forge(id: request.params.id)
    .fetch().then (article) -> response.json article
    .catch (e) -> next e


Controller["@require"] = ["models/news/article"]
Controller["@routes"] = ["/news/articles/:id"]
Controller["@singleton"] = true
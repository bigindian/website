Controller = module.exports = (Article) ->
  (request, response, next) ->
    Article.forge id: request.params.id
    .fetch().then (article) ->
      article.save {clicks_count: 1 + article.get "clicks_count"}, patch: true
      .then -> response.json article
    .catch (error) -> next error


Controller["@require"] = ["models/news/article"]
Controller["@routes"] = ["/news/articles/:id/click"]
Controller["@singleton"] = true
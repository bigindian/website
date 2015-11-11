Controller = module.exports = (Article) ->
  (request, response, next) ->
    Article.query().then (articles) ->  response.json articles
    .catch (e) -> next e


Controller["@require"] = ["models/news/article"]
Controller["@routes"] = ["/news/articles"]
Controller["@singleton"] = true
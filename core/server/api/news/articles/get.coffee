validator = require "validator"


Controller = module.exports = (Article) ->
  (request, response, next) ->
    q = request.query

    limit = if validator.isInt q.limit, {min: 0, max: 50} then q.limit else 15
    orderBy = if q.top? then "hotness" else "published_at"

    Article.forge().query (qb) ->
      qb.orderBy orderBy, "desc"
      qb.limit limit
    .fetchAll().then (collection) -> response.json collection


Controller["@require"] = ["models/news/article"]
Controller["@routes"] = ["/news/articles"]
Controller["@singleton"] = true
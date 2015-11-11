Promise = require "bluebird"
rsj     = require "rsj"
helpers = require "../helpers"


Model = module.exports = (Bookshelf, Article) ->
  Bookshelf.Model.extend
    tableName: "news_feeds"
    require: true
    resultsPerPage: 20


    # enums: categories: tableName: "news_categories"


    categories: -> @hasMany "news_categories"
    articles: -> @hasMany Article, "feed"


    getFeed: -> new Promise (resolve) =>
      @save {checked_at: new Date()}, patch: true

      rsj.r2j @get("feed_url"), (json) -> resolve JSON.parse json


    onArticleAdded: (article) ->
      @save {
        last_article_at: new Date()
        last_article: article.toJSON()
      }, patch: true


Model["@require"] = [
  "models/base/bookshelf"
  "models/news/article"
]
Model["@singleton"] = true
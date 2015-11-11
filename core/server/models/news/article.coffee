helpers = require "../helpers"


Model = module.exports = (Bookshelf) ->
  Bookshelf.Model.extend
    tableName: "news_feed_articles"
    require: true


Model["@require"] = ["models/base/bookshelf"]
Model["@singleton"] = true
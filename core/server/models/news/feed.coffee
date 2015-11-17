Promise    = require "bluebird"
FeedParser = require "feedparser"
request    = require "request"


Model = module.exports = (Bookshelf) ->
  Bookshelf.model "news.feed", Bookshelf.Model.extend
    tableName: "news_feeds"
    require: true
    cache: true
    resultsPerPage: 20


    categories: -> @hasMany "news_categories"
    articles: -> @hasMany "news.article", "feed"


    getFeed: -> new Promise (resolve, reject) =>
      @save {checked_at: new Date()}, patch: true

      req = request @get "feed_url"
      feedparser = new FeedParser
      items = []

      # Execute the request
      req.on "error", (error) -> reject error
      req.on "response", (res) ->
        stream = this
        if res.statusCode is not 200 then return @emit "error", new Error "Bad status code"
        stream.pipe feedparser

      # Once the request is completed, start parsing the RSS feed
      feedparser.on "error", (error) -> reject error
      feedparser.on "readable", ->
        stream = this
        meta = @meta
        while item = stream.read() then items.push item
      feedparser.on "end", -> resolve items

      # If the request does not complete in 5 seconds, then we skip it!
      setTimeout (-> reject new Error "timeout"), 5000



Model["@require"] = ["models/base/bookshelf"]
Model["@singleton"] = true
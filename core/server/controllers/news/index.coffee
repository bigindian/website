Promise = require "bluebird"


Controller = module.exports = (Cache, Feed, Article) ->
  (request, response, next) ->
    page = request.params.page or 1
    cacheKey = "main/news/index/#{page}"


    feedsPromise = ->
      Feed.forge().fetchAll().then (collection) ->
        feeds = do -> collection.at i for i in [0...collection.length]

        Promise.map feeds, (feed) ->
          # For every feed, take out at most 10 articles
          feed.related "articles"
          .query (qb) ->
            qb.orderBy "published_at", "desc"
            qb.limit 10
          .fetch().then (articles) -> feed.set "articles", articles


    topArticlesPromise = ->
      Article.forge().query (qb) ->
        qb.orderBy "hotness", "desc"
        qb.limit 15
      .fetchAll()


    recentArticlesPromise = ->
      Article.forge().query (qb) ->
        qb.orderBy "published_at", "desc"
        qb.limit 10
      .fetchAll()


    Promise.props
      top: topArticlesPromise()
      recent: recentArticlesPromise()
      feeds: feedsPromise()
    .then (data) ->
      response.render "main/news/index",
        data: data
        metaRobots: "noarchive"
        title: null

    .catch (e) -> next e


Controller["@require"] = [
  "libraries/cache"
  "models/news/feed"
  "models/news/article"
]
Controller["@routes"] = [
  ""
  "/page/:page"
]
Controller["@singleton"] = true
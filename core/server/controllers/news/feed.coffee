Promise = require "bluebird"


Controller = module.exports = (Cache, Feed, Article) ->
  (request, response, next) ->
    page = request.params.page or 1
    cacheKey = "main/news/feed/#{request.params.slug}/#{page}"


    Feed.forge slug: request.params.slug
    .fetch().then (feed) ->

      # Get the articles for the feed
      feed.related("articles").query (qb) ->
        qb.orderBy "published_at", "desc"
        qb.limit 100

      .fetch().then (articles) ->
        feed.set "articles", articles
        response.render "main/info/about",
          data: feed.toJSON()
          metaRobots: "noarchive"
          title: null

    .catch (e) -> next e


Controller["@require"] = [
  "libraries/cache"
  "models/news/feed"
  "models/news/article"
]
Controller["@routes"] = [
  "/feed/:slug"
  "/feed/:slug/page/:page"
]
Controller["@singleton"] = true
Promise       = require "bluebird"
read          = require "node-readability"
htmlToText    = require "html-to-text"
readingTime   = require "reading-time"
MetaInspector = require "node-metainspector"


Cron = module.exports = (IoC, Feed, Article) ->
  logger = IoC.create "igloo/logger"
  name = "[cron:fetch-articles]"

  # A lock variable to avoid multiple instances of the cron script.
  isRunning = false

  ###
  **fetchInformation()** Gets information about the given feed article and
  returns a Promise which resolves to a JSON with properties about the article
  (excerpt, reading time etc..).

  The promise fails if any error occurs.
  ###
  fetchInformation = (url, EXCERPT_LENGTH=200) -> new Promise (resolve, reject) ->
    read url, (error, article, meta) ->
      if error then return reject error

      text = htmlToText.fromString article.content,
        hideLinkHrefIfSameAsText: true
        ignoreHref: true
        ignoreImage: true

      onMetaInspectFinish = (meta={}) ->
        resolve
          title: article.title
          excerpt: text.substr 0, text.lastIndexOf " ", EXCERPT_LENGTH
          image_url: meta.image
          meta: time: readingTime text

      client = new MetaInspector url
      client.on "fetch", -> onMetaInspectFinish client
      client.on "error", (error) -> reject error
      client.fetch()



  ###
  **processFeed()** A helper function to take a feed (Bookshelf Model) and
  scrape the articles in it.
  ###
  processFeed = (feed) ->
    logger.debug name, "processing feed #{feed.get 'domain'}"

    feed.getFeed().then (articles=[]) ->
      logger.debug name, "got feed, found #{articles.length} articles"
      Promise.each articles, (article) -> processArticles article, feed
    .catch (e) ->
      logger.error name, "fetching feed #{feed.get 'domain'} failed"
      logger.error e


  ###
  **processArticles()** A helper function that takes an article (JSON) and
  fetches information about it and saves it into the DB.
  ###
  processArticles = (article, feed) ->
    logger.debug name, "processing article #{article.link}"
    url = article.link

    # First check if the article exists in the DB
    Article.forge(url: url).fetch()
    .then -> logger.debug name, "skipping article #{url}"

    # If it didn't then it'll throw a NotFound error and end up here.
    .catch ->
      logger.debug name, "adding article #{url}"

      # Fetch information about the article and then save it into the DB
      fetchInformation url
      .then (data) ->
        data.url = url
        data.feed = feed.id

        # Get the published date
        data.published_at = new Date article.pubDate

        # This ensures that the published date stay below today's date
        data.published_at = new Date Math.min data.published_at, new Date

        Article.forge(data).save()
        .then (model) -> logger.info name, "added article #{url}"
    .catch (e) ->
      logger.error name, "failed processing article #{article.link}"
      logger.error e


  job = ->
    if isRunning
      return logger.info name, "script is already running"
    else isRunning = true
    Feed.fetchAll().then (collection) ->
      currentIndex = 0

      # Get the feeds as an Array
      feeds = collection.toArray()

      Promise.each feeds, processFeed
      .finally ->
        isRunning = false
        logger.debug name, "done"

    logger.info name, "running"


Cron["@require"] = [
  "$container"
  "models/news/feed"
  "models/news/article"
]
Cron["@singleton"] = true
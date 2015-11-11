Promise       = require "bluebird"
read          = require "node-readability"
htmlToText    = require "html-to-text"
readingTime   = require "reading-time"
MetaInspector = require "node-metainspector"


exports = module.exports = (IoC, Feed, Article) ->
  logger = IoC.create "igloo/logger"
  name = "[cron:fetch-articles]"

  ###
  **fetchInformation()** Gets information about the given URL and returns a
  JSON which can be used for initializing the story.
  ###
  fetchInformation = (url, EXCERPT_LENGTH=500) -> new Promise (resolve, reject) ->
    read url, (error, article, meta) ->
      if error then return reject error

      text = htmlToText.fromString article.content,
        hideLinkHrefIfSameAsText: true
        ignoreHref: true
        ignoreImage: true

      onMetaInspectFinish = (meta={}) ->
        resolve
          title: meta.title
          excerpt: text.substr 0, text.lastIndexOf " ", EXCERPT_LENGTH
          image_url: meta.image
          meta:
            time: readingTime text


      client = new MetaInspector url
      client.on "fetch", -> onMetaInspectFinish client
      client.on "error", (error) -> reject error
      client.fetch()


  processFeed = (feed) ->
    feed.getFeed().then (articles) ->
      _performAsQueue articles, (article) -> processArticles article, feed


  processArticles = (article, feed) ->
    url = article.link

    Article.forge(url: url).fetch()
    .then -> logger.debug name, "article #{url} exists"
    .catch ->
      fetchInformation url
      .then (data) ->
        data.url = url
        data.feed = feed.id
        logger.debug name, "adding article #{url}"

        article = new Article data
        article.save()
        .then -> feed.onArticleAdded article


  _performAsQueue = (array=[], fn, index=0) ->
    if index >= array.length then return

    job = array[index]

    fn(job).finally -> _performAsQueue array, fn, index + 1

  job = ->
    Feed.fetchAll().then (collection) ->
      currentIndex = 0

      feeds = do -> collection.at index for index in [0...collection.length]

      _performAsQueue feeds, processFeed
      .then -> console.log "done"

      # for index in [0...collection.length]
      #   feed = collection.at index
      #   feed.getFeed().then (json) ->
      #     #   console.log "hit"
      #     # link = new Links
      #     #   title: json.title
      #     #   url: json.url

      #     new Promise (resolve, reject) ->

      #     # link.save
      #     # Links.register
      #     for article in json
      #       processArticles article.link


    logger.info name, "running"
    # Cache.del "route:api/categories/counters"


exports["@require"] = [
  "$container"
  "models/news/feed"
  "models/news/article"
]
exports["@singleton"] = true
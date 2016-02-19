Promise = require "bluebird"
request = require "request"
rsj     = require "rsj"
_       = require "underscore"




Cron = module.exports = (IoC, Settings, Feed) ->
  logger = IoC.create "igloo/logger"
  name = "[cron:fetch-articles]"

  MAX_ARTICLES_PER_FEED = 10
  TIMELIMIT_PER_FEED = 5 * 1000


  job = ->
    logger.info name, "running"

    links = []

    getRss = (feed) -> new Promise (resolve, reject) ->
      rsj.r2j feed, (json) -> resolve JSON.parse json
      setTimeout (-> resolve []), TIMELIMIT_PER_FEED

    # Parse the feed and get at most 10 links
    downloadFeed = (feed) ->
      getRss(feed.url).then (json) ->
        logger.debug name, "got #{json.length} links from #{feed.url}"
        count = 0

        sampleLinks = _.sample json, MAX_ARTICLES_PER_FEED
        links = _.union links, sampleLinks


    # Publish the given link to the server. This function creates an internal
    # requests and chains the request to the story's POST method.
    publishLink = (link) ->
      data =
        method: "POST"
        uri: "#{Settings.url}/api/news/stories"
        headers: "x-recaptcha-bypass": Settings.reCaptcha.bypassKey
        form:
          url: link.link
          is_from_feed: true

      logger.debug name, "publishing: #{link.title}"
      request(data).on "response", (response) ->


    Feed.find().limit(4).exec().then (feeds) ->
      Promise.each feeds, downloadFeed
      .finally ->
        logger.info name, "collected #{links.length} links from #{feeds.length} feeds"

        sampleLinks = _.sample links, _.random 3, 10
        logger.info name, "picked #{sampleLinks.length} sample links"

        Promise.each sampleLinks, publishLink


Cron["@require"] = [
  "$container"
  "igloo/settings"
  "models/news/feed"
]
Cron["@singleton"] = true
RSS = require "rss"



# ### loop over data and add to feed ###
# feed.item
#   title: "item title"
#   description: "use this for the content. It can include html."
#   url: "http://example.com/article4?this&that"
#   guid: "1123"
#   author: "Guest Author"
#   date: "May 27, 2012"

Controller = module.exports = (Cache, Story) ->
  createFeed = ->
    new RSS
      title: "The Big Indian News"
      description: "description"
      feed_url: "https://thebigindian.news/rss.xml"
      site_url: "https://thebigindian.news"
      image_url: "https://thebigindian.news/images/logo.png"
      managingEditor: "Steven Enamakel"
      webMaster: "Steven Enamakel"
      copyright: "2015 The Big Indian News"
      language: "en"
      pubDate: "August 20, 2015 04:00:00 GMT"
      ttl: "60"

  (request, response, next) ->
    cacheKey = "main/rss"

    Cache.get cacheKey
    .catch ->
      feed = createFeed()

      options =
        limit: 30
        sort: hotness: -1

      Story.paginate {}, options
      .then (results) ->
        for story in results.docs
          feed.item
            title: story.title
            description: story.description
            url: story.url

        xml = feed.xml()

        # And then cache it
        Cache.set cacheKey, xml, 60 * 1 # 1 minute cache

    .then (xml) ->
      response.setHeader "content-type", "text/xml;charset=UTF-8"
      response.end xml

    .catch (e) -> next e



Controller["@require"] = [
  "libraries/cache"
  "models/news/story"
]
Controller["@routes"] = ["/rss"]
Controller["@singleton"] = true
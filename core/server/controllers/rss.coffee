RSS = require "rss"

### lets create an rss feed ###



# ### loop over data and add to feed ###
# feed.item
#   title: "item title"
#   description: "use this for the content. It can include html."
#   url: "http://example.com/article4?this&that"
#   guid: "1123"
#   author: "Guest Author"
#   date: "May 27, 2012"


# Controller for the privacy page. Simply displays the privacy policy view.
Controller = module.exports = (Cache, Stories) ->

  createFeed = ->
    new RSS
      title: "The Big Indian News"
      description: "description"
      feed_url: "http://example.com/rss.xml"
      site_url: "http://example.com"
      image_url: "http://example.com/icon.png"
      managingEditor: "Steven Enamakel"
      webMaster: "Steven Enamakel"
      copyright: "2013 Steven Enamakel"
      language: "en"
      pubDate: "May 20, 2012 04:00:00 GMT"
      ttl: "60"
      custom_namespaces: "itunes": "http://www.itunes.com/dtds/podcast-1.0.dtd"

  (request, response, next) ->
    cacheKey = "main/rss"

    Cache.get cacheKey
    .catch ->

      feed = createFeed()

      Stories.top().then (results) ->
        for story in results.collection.toJSON()
          feed.item
            title: story.title
            description: story.description
            url: story.url

        xml = feed.xml()

        #! And then cache it
        Cache.set cacheKey, xml, 60 * 1 # 1 minute cache

    .then (xml) ->
      response.setHeader "content-type", "text/xml;charset=UTF-8"
      response.end xml

    .catch (e) -> next e



Controller["@require"] = [
  "libraries/cache"
  "models/news/stories"
]
Controller["@routes"] = ["/rss"]
Controller["@singleton"] = true
# Model = module.exports = (Bookshelf) ->
#   createUID = (length=5)->
#     text = ""
#     possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#     for i in [0...length]
#       text += possible.charAt Math.floor Math.random() * possible.length
#     text

#   # **ACTIVITY_WEIGHT** Amount that any activity inside an article gets.
#   ACTIVITY_WEIGHT = 1


#   # **CREATION_WINDOW** The window variable is used narrow down how effective
#   # the creation date is when the post's hotness is calculated. A smaller window
#   # allows lesser activity before the post makes it to the front page. A bigger
#   # window allows more room for old articles to become popular with clicks.
#   #
#   # As the site grows, you might want to shrink this down.
#   #
#   # Right now we set the window to 5 hours which gives any article a 5 hour
#   # window to allow it to start ranking itself among other articles.
#   #
#   # An article with 200 clicks, will get an increase hotness of ~5. By then it
#   # gets passed by a newer article 24 hours (~25 hours acutally, with 0 clicks)
#   # later.
#   CREATION_WINDOW = 5 * 60 * 60 * 1000 # 5hrs, 60 min, 60 seconds, 1000 ms


#   Bookshelf.model "news.article", Bookshelf.Model.extend
#     tableName: "news_feed_articles"
#     require: true


#     feed: -> @belongsTo "news.feed", "feed"


#     updateHotness: ->
#       # Calculate the activity's score
#       activityScore = @get("clicks_count") or 0

#       # Now using the log function is really nice because it evens out
#       # activity after a bunch of clicks.
#       activityPoints = Math.log activityScore + 1, 10

#       # The creation points is set so that newer posts get more hotness than
#       # older ones. The window variable is used narrow down how effective
#       # already trending ones will take the top spot.
#       createdDate = Number new Date(@get "created_at").getTime() or Date.now()
#       creationPoints = createdDate / CREATION_WINDOW

#       # The final hotness is simply the sum of all the different points.
#       hotness = activityPoints + creationPoints

#       # Round off the hotness so that postgres stays happy and set it to the
#       # model!
#       #
#       # See http://stackoverflow.com/questions/11832914/round-to-at-most-2-decimal-places-in-javascript
#       power = Math.pow 10, 7
#       hotness: Math.round(hotness * power) / power
#       activity_hotness: Math.round(activityPoints * power) / power


#     constructor: ->
#       Bookshelf.Model.apply this, arguments

#       # Every time an Article is being created, we have to give it some unique
#       # values.
#       @on "creating", (model, attributes={}, options) ->
#         model.set "slug", createUID 10


#       # Every time an Article is being saved, we'll update it's hotness so that
#       # our algorithims can properly learn properly.
#       @on "saving", (model, attributes={}, options) ->
#         # Get the hotness values
#         values = model.updateHotness()

#         # Pass them as parameters to be changed/inserted
#         attributes.hotness = values.hotness
#         attributes.activity_hotness = values.activity_hotness

#       # Every time an Article is created, we need to inform the feed that it was
#       # associated with that the # of articles under it have increased.
#       @on "created", (model, attributes, options) ->
#         model.related "feed"
#         .fetch().then (feed) ->
#           # Fetch some old value
#           old_articles_count = @get("articles_count") or 0
#           old_refresh_interval = @get("refresh_interval") or 0
#           old_last_article_at = @get "last_article_at"

#           # Preprase some new valuse
#           new_articles_count = old_articles_count + 1
#           new_refresh_interval = old_refresh_interval

#           # Now sometimes the feed is empty, so we prepare a query for the first
#           # to insert the first post.
#           if not old_last_article_at? or old_articles_count is 0
#             return feed.save {
#               refresh_interval: 0
#               articles_count: 1
#               last_article_at: model.get "published_at"
#             }, patch: true

#           # If this is not our first time, then we start re-calculating the
#           # refresh_interval for this next post.

#           # Get the UTC time values for the given dates
#           old_last_article_at = old_last_article_at.getTime()
#           current_article_at = model.get("published_at").getTime()

#           # Find out how far away the two dates are. Will give a result in ms.
#           currentInterval = current_article_at - old_last_article_at

#           if currentInterval >= 0
#             # Sometimes some articles are pretty ancient and have a tendency to
#             # greatly influence the general average. So we, cap the interval so
#             # that articles are considered to be at most a day old from the
#             # last article.
#             #
#             # This way, we make sure that our refresh_interval will trigger a
#             # refresh at most withing a day.
#             currentInterval = Math.min currentInterval, 86400 * 1000

#             # The new_refresh_interval is simply an average of all the intervals
#             # together. The code below re-calculates the new average by simply
#             # re-using the previous average.
#             old_articles_interval = old_refresh_interval * old_articles_count
#             new_refresh_interval = (old_articles_interval + currentInterval) /
#               new_articles_count

#           # Once we've recalculated the refresh_interval, we update the
#           # next_refresh_date so that we can use that field and run simple DB
#           # queries to figure out which is the next article to be updated.
#           new_refresh_date = new Date Date.now() + new_refresh_interval

#           feed.save {
#             refresh_interval: new_refresh_interval
#             next_refresh_date: new_refresh_date
#             articles_count: new_articles_count
#             last_article_at: model.get "published_at"
#           }, patch: true



# Model["@require"] = ["models/base/bookshelf"]
# Model["@singleton"] = true
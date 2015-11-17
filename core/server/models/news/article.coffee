Model = module.exports = (Bookshelf) ->
  # **ACTIVITY_WEIGHT** Amount that any activity inside an article gets.
  ACTIVITY_WEIGHT = 1


  # **CREATION_WINDOW** The window variable is used narrow down how effective
  # the creation date is when the post's hotness is calculated. A smaller window
  # allows lesser activity before the post makes it to the front page. A bigger
  # window allows more room for old articles to become popular with clicks.
  #
  # As the site grows, you might want to shrink this down.
  #
  # Right now we set the window to 5 hours which gives any article a 5 hour
  # window to allow it to start ranking itself among other articles.
  #
  # An article with 200 clicks, will get an increase hotness of ~5. By then it
  # gets passed by a newer article 24 hours (~25 hours acutally, with 0 clicks)
  # later.
  CREATION_WINDOW = 5 * 60 * 60 * 1000 # 5hrs, 60 min, 60 seconds, 1000 ms


  Bookshelf.model "news.article", Bookshelf.Model.extend
    tableName: "news_feed_articles"
    require: true


    feed: -> @belongsTo "news.feed", "feed"


    updateHotness: ->
      # Calculate the activity's score
      activityScore = @get("clicks_count") or 0

      # Now using the log function is really nice because it evens out
      # activity after a bunch of clicks.
      activityPoints = Math.log activityScore + 1, 10

      # The creation points is set so that newer posts get more hotness than
      # older ones. The window variable is used narrow down how effective
      # already trending ones will take the top spot.
      createdDate = Number new Date(@get "published_at").getTime() or Date.now()
      creationPoints = createdDate / CREATION_WINDOW

      # The final hotness is simply the sum of all the different points.
      hotness = activityPoints + creationPoints

      # Round off the hotness so that postgres stays happy and set it to the
      # model!
      #
      # See http://stackoverflow.com/questions/11832914/round-to-at-most-2-decimal-places-in-javascript
      power = Math.pow 10, 7
      hotness: Math.round(hotness * power) / power
      activity_hotness: Math.round(activityPoints * power) / power


    constructor: ->
      Bookshelf.Model.apply this, arguments

      # Every time an Article is being saved, we'll update it's hotness so that
      # our algorithims can properly learn properly.
      @on "saving", (model, attributes={}, options) ->
        # Get the hotness values
        values = model.updateHotness()

        # Pass them as parameters to be changed/inserted
        attributes.hotness = values.hotness
        attributes.activity_hotness = values.activity_hotness

      # Every time an Article is created, we need to inform the feed that it was
      # associated with that the # of articles under it have increased.
      @on "created", (model, attributes, options) ->
        model.related "feed"
        .fetch().then (feed) ->
          feed.save {
            # refresh_rate # do something about refresh rate here...
            articles_count: 1 + @get("articles_count") or 0
            last_article_at: new Date()
          }, patch: true



Model["@require"] = ["models/base/bookshelf"]
Model["@singleton"] = true
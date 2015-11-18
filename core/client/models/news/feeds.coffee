Model = module.exports = ($log, $interval, BackboneModel, BackboneCollection, Api, Articles) ->
  logger = $log.init Model.tag
  logger.log "initializing"

  hexToRgb = (hex) ->
    result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec hex
    if result
      r: parseInt result[1], 16
      g: parseInt result[2], 16
      b: parseInt result[3], 16
    else null


  class Feeds
    @Model: BackboneModel.extend
      urlRoot: "/api/news/feeds"
      initialize: ->
        if @has "articles"
          articles = @get "articles"
          @articles = new Articles.Collection articles,
            updateUrl: "/news/feeds/#{@id}/articles"

        # Give it the RGB component
        @rgb = hexToRgb @get "color"

        # Start the update countdown
        @startUpdateCountdown()

      startUpdateCountdown: ->
        @update_countdown_date = new Date @get "next_refresh_date"
        interval = =>
          old_date = @update_countdown_date.getTime()
          @update_countdown_date = new Date old_date - 1000

          if old_date < Date.now()
            @stopUpdateCountdown()
            @onCountdownFinish()

        @interval_promise = $interval interval, 1000


      stopUpdateCountdown: -> $interval.cancel @interval_promise

      onCountdownFinish: -> @articles.update().finally => @startUpdateCountdown()


    @Collection = BackboneCollection.extend model: Feeds.Model


Model.tag = "model:feeds"
Model.$inject = [
  "$log"
  "$interval"
  "BackboneModel"
  "BackboneCollection"
  "@api"
  "@models/news/articles"
]
Model = module.exports = ($log, BackboneModel, BackboneCollection, Api, Articles) ->
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

        @rgb = hexToRgb @get "color"


    @Collection = BackboneCollection.extend model: Feeds.Model


Model.tag = "model:user"
Model.$inject = [
  "$log"
  "BackboneModel"
  "BackboneCollection"
  "@api"
  "@models/news/articles"
]
Model = module.exports = ($log, BackboneModel, BackboneCollection, Api) ->
  logger = $log.init Model.tag
  logger.log "initializing"


  class Articles
    @Model: BackboneModel.extend
      urlRoot: "/api/news/articles"

    @Collection = BackboneCollection.extend
      model: Articles.Model
      initialize: (array, options={}) -> {@updateUrl=""} = options
      update: -> Api.get(@updateUrl).then (response) => @set response.data


Model.tag = "model:articles"
Model.$inject = [
  "$log"
  "BackboneModel"
  "BackboneCollection"
  "@api"
]
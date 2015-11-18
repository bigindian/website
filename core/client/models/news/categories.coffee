Model = module.exports = ($log, BackboneModel, BackboneCollection) ->
  logger = $log.init Model.tag
  logger.log "initializing"


  class Categories
    @Model: BackboneModel.extend urlRoot: "/api/news/categories"
    @Collection = BackboneCollection.extend model: Categories.Model


Model.tag = "model:categories"
Model.$inject = [
  "$log"
  "BackboneModel"
  "BackboneCollection"
]
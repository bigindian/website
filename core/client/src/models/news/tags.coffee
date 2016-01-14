Model = module.exports = ($log, BackboneModel, BackboneCollection, BackboneCache) ->
  logger = $log.init Model.tag
  logger.log "initializing"

  # cache.download()

  class Tags
    @Model: BackboneModel.extend urlRoot: "/tags"
    @Collection: BackboneCollection.extend model: Tags.Model
    @Cache: new (ModelCache = BackboneCache.extend
      downloadUrl: "/news/tags"
      md5Key: "fuck"
      model: Tags.Model
      tag: "enum:#{Model.tag}")


Model.tag = "model:news:tags"
Model.$inject = [
  "$log"
  "BackboneModel"
  "BackboneCollection"
  "BackboneCache"
]
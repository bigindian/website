BaseApi = module.exports = ($http, $log, $q, Environment, Storage, Api, BaseModel, BaseCollection) ->
  # class
  #   tag: "baseapi"
  #   baseUrl: "/"
  #   enableCache: false
  #   cache: {}
  #   defaults: {}

  #   constructor: ->
  #     @logger = $log.init @tag
  #     @logger.log "initializing"

  #     @model ?= BaseModel.extend @defaults
  #     @collection ?= BaseCollection.extend @model

  #     @api = new Api
  #       model: @model
  #       collection: @collection
  #       baseUrl: @baseUrl


  #   ###
  #     Get a item with the a specific id.
  #   ###
  #   get: (id, cache=@enableCache) ->
  #     if cache then Storage
  #     @api.get "/#{id}"


  #   findById: (id) -> @get id


BaseApi.$inject = [
  "$http"
  "$log"
  "$q"
  "@environment"
  "@storage"
  "@api"
  "@models/base/model"
  "@models/base/collection"
]
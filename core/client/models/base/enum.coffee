BaseEnum = module.exports = ($http, $log, $q, Environment, Storage, $resource) ->
  new class
  # class Enum
  #   download: ->

  # class Enum extends BaseApi
  #   tag: "enum"
  #   cache: true
  #   # model: BaseModel
  #   md5Key: "insert-md5-key"
  #   _downloadedFlag: false

  #   downloadUrl: ""
  #   url: (path="") -> "#{Environment.url}#{@downloadUrl()}#{path}"


  #   getAll: -> @data


  #   get: (key) -> @data[key]


  #   findById: (id) -> for obj in @data then if obj.id is id then return obj


  #   onChange: -> null


  #   download: ->
  #     if @_downloadedFlag then return @logger.log "already downloaded"
  #     @logger.log "preparing to download from server"
  #     @logger.debug "downloading from", @api.url  @downloadUrl

  #     # Variables to point to our cache
  #     cacheKey = "enum:#{@api.url @downloadUrl}"
  #     md5CacheKey = "md5:#{@md5Key}"

  #     Storage.local md5CacheKey
  #     .then (md5Hash) =>
  #       #! If the md5 key changes then we clear the cache so that it reloads
  #       if md5Hash != Environment.md5[@md5Key]
  #         @logger.log "local md5 hash is different; flushing cache"
  #         Storage.local cacheKey, null
  #       else @logger.log "local md5 hash is the same; not flushing cache"

  #       #! Now check for the data in cache if it exists
  #       Storage.local cacheKey

  #     .then (cache) =>
  #       @logger.log "retrieved from cache"

  #       $q (resolve, reject) =>
  #         if @cache and cache?
  #           # data was found in cache, prepare to parse it and return
  #           @logger.log "parsing from cache"
  #           resolve @data = window.angular.fromJson cache
  #         else reject "couldn't parse from cache"

  #     # Something went wrong while parsing the cached data or there was nothing
  #     # in the cache. No problem, we'll retrieve it from the API.
  #     .catch (error) =>
  #       @logger.log "retrieving from API"

  #       @api.get @downloadUrl
  #       .then (collection) =>
  #         window.a = collection
  #         @logger.log "downloaded", collection
  #         @data = collection
  #         Storage.local md5CacheKey, Environment.md5[@md5Key]
  #         Storage.local cacheKey, window.angular.toJson @data.toJSON()

  #     .then (data) =>
  #       @logger.log "retrieved"
  #       @_downloadedFlag = true
  #       @onChange @data


BaseEnum.$inject = [
  "$http"
  "$log"
  "$q"
  "@environment"
  "@storage"
  # "@models/base/api"
  # "@models/base/model"
  "$resource"
]
BackboneCache = module.exports = ($http, $log, $q, Environment, Storage, Api, BackboneModel, BackboneCollection, angular) ->
  BackboneCollection.extend
    md5Key: "insert-md5-key"
    downloadUrl: ""
    tag: "enum"
    model: BackboneModel.extend()
    cache: true

    _downloadedFlag: false


    url: (path="") -> "#{Environment.url}/api#{path}"


    download: ->
      @logger = $log.init @tag
      @logger.log "initializing"
      if @_downloadedFlag then return @logger.log "already downloaded"

      @logger.log "preparing to download from server"
      window.aa = this
      console.log 'hi'

      # Variables to point to our cache
      cacheKey = "cache:modal:#{@url @downloadUrl}"
      md5CacheKey = "md5:#{@md5Key}"

      @logger.debug md5CacheKey

      @logger.debug "downloading from", @url @downloadUrl
      Storage.local(md5CacheKey).then (md5Hash) =>
        # If the md5 key changes then we clear the cache so that it reloads
        if md5Hash != Environment.md5[@md5Key]
          @logger.log "local md5 hash is different; flushing cache"
          Storage.local cacheKey, null
        else @logger.log "local md5 hash is the same; not flushing cache"

        # Now check for the data in cache if it exists
        Storage.local cacheKey

      .then (cache) =>
        @logger.log "retrieved from cache"

        $q (resolve, reject) =>
          if @cache and cache?
            # data was found in cache, prepare to parse it and return
            @logger.log "parsing from cache"
            resolve @data = window.angular.fromJson cache
          else reject "couldn't parse from cache"

      # Something went wrong while parsing the cached data or there was nothing
      # in the cache. No problem, we'll retrieve it from the API.
      .catch (error) =>
        @logger.log "retrieving from API"

        Api.get @downloadUrl
        .success (collection) =>

          collection = do => new @model item for item in collection
              # console.log item =
          @logger.log "downloaded", collection
          @add collection
          Storage.local md5CacheKey, Environment.md5[@md5Key]
          Storage.local cacheKey, angular.toJson collection

      .then (data) =>
        @logger.log "retrieved"
        @_downloadedFlag = true
        # @onChange @data


BackboneCache.$inject = [
  "$http"
  "$log"
  "$q"
  "@environment"
  "@storage"
  "@api"
  # "@models/base/api"
  # "@models/base/model"
  "BackboneModel"
  "BackboneCollection"
  "angular"
]
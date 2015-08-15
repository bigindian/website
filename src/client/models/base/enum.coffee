Model = ($http, $log, $q, Environment, Storage) ->
  class Enum
    tag: "enum"
    cache: true
    _downloadedFlag: false

    constructor: ->
      @logger = $log.init @tag
      @logger.log "initializing"


    downloadUrl: -> ""
    url: (path="") -> "#{Environment.url}#{@downloadUrl()}#{path}"


    getAll: -> @data


    get: (key) -> @data[key]


    findById: (id) -> for obj in @data then if obj._id is id then return obj


    onChange: -> null


    download: ->
      if @_downloadedFlag then return

      url = @downloadUrl()
      cacheKey = "enum:#{url}"

      @logger.debug "downloading from", url

      # Now check for the data in cache if it exists
      Storage.local cacheKey
      .then (cache) =>
        @logger.log "retrieved from cache"

        $q (resolve, reject) =>
          if @cache and cache?
            # data was found in cache, prepare to parse it and return
            @logger.log "parsing from cache"
            resolve @data = angular.fromJson cache
          else reject "couldn't parse from cache"

      # Something went wrong while parsing the cached data or there was nothing
      # in the cache. No problem, we'll retrieve it from the API.
      .catch =>
        @logger.log "retrieving from API"
        $http.get @url()
        .success (@data) => Storage.local cacheKey, angular.toJson @data

      .then =>
        @_downloadedFlag = true
        @onChange @date
        @logger.log "downloaded"




Model.$inject = [
  "$http"
  "$log"
  "$q"
  "@environment"
  "@storage"
]

module.exports = Model
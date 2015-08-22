###
Checks the JS version from the server side and setups the local storage
based on it. If the JS version from the local and the server are
different, then reset the local Storage. Otherwise have the local storage
cache every page template that it downloads.

Also, if the browser does not support localStorage uses fallback temporary
Storage. (which technically doesn't really help.. but whatever..)
###
CacheScripts = ($http, $timeout, $window, $log, $q, Storage, Environment) ->
  logger = $log.init CacheScripts.tag

  fallback = false
  md5 = Environment.md5 or {}

  ###
  This function checks the version of the different kinds of data that is
  stored in the cache. Basically the version control allows the server to
  demand the clients to clear the cache whenever it wants to and update
  itself with the new version.
  ###
  checkVersions = ->
    logger.log "checking cache version"
    storageKeys = []

    # Now start iterating through every key in the localStorage
    for i in [0...localStorage.length]
      # Filter out keys that don't start with "script:"
      storageKey = localStorage.key(i) or ""
      keyParts = storageKey.split ":"
      if keyParts[0] is "md5"
        filename = keyParts[1]
        # If the MD5 sum does not match then clear the localStorage cache
        # if md5[filename] != Storage.local storageKey
        #   logger.log "clearing cache for file:", filename
        #   Storage.local storageKey, null



  ###
  This function is responsible for saving all the startup scripts
  (eg: jQuery, Backbone, Masonry) into the localStorage cache. This way the
  next time the user open the page, site will immediately load the scripts
  from the cache and avoid making requests from the CDN.

  The code that loads the script that is saved in the local path of the app.
  This is done, because most browsers don't allow cross-browser requests
  and saving the scripts local is a solution for this.
  ###
  cacheStartupScripts = ->
    if fallback then return
    logger.log "caching startup scripts via async"

    # The list of scripts is accessible to us by the global variable "scripts"
    for script in $window.scripts then do (script) ->
      if not script.local? then return

      cacheKey = "script:#{script.id}"
      md5ID = "md5:#{script.id}"

      localMD5 = null
      remoteMD5 = md5[script.id]


      Storage.local(md5ID).then (localMD5) ->
        logger.log "md5 for script '#{script.id}' exists"
        # logger.log localMD5, remoteMD5

        #! If the md5 hashes don't match then clear then clear the storage
        if localMD5 != remoteMD5
          logger.log "md5 for script '#{script.id}' don't match"
          Storage.local cacheKey, null

        #! Check if the script already exists in the cache
        Storage.local cacheKey
        .then -> logger.log "script '#{script.id}' exists in cache"

      #! If the script was not in cache then start fetching the local version
      #! of the script asynchronously, and then save it into the cache.
      .catch (error) ->
        logger.log "script could not be found in cache, caching:", script.id
        try
          #! Update the script and the MD5 hash of it
          $http.get(script.local).success (data) ->
            Storage.local cacheKey, data
            Storage.local md5ID, remoteMD5
            logger.log "cached script:", script.id

        catch e
          logger.error "could not cache script", script.id
          logger.error "url was", url
          logger.error e.stack


  new ->
    logger.log "initializing"

    # Check if localStorage is supported
    fallback = false or Storage.fallback
    if fallback then return

    # Cache the startup scripts for the next time the user visits the
    # site. Begin the cache after 7 seconds so that other AJAX requests
    # finish by then.
    checkVersions()
    $timeout cacheStartupScripts, 1000


CacheScripts.tag = "cache-scripts"
CacheScripts.$inject = [
  "$http"
  "$timeout"
  "$window"
  "$log"
  "$q"
  "@storage"
  "@environment"
]
module.exports = CacheScripts
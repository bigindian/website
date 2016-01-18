LocalStorageCache = module.exports = ($cacheFactory) ->
  PREFIX = "$http"
  cache = $cacheFactory "$httpCache", {}


  cache.get = (key) ->
    lruEntry = localStorage.getItem "#{PREFIX}:#{key}"
    if not lruEntry? then return

    # Cache miss
    lruEntry = JSON.parse lruEntry
    lruEntry.data


  cache.put = (key, value) ->
    if typeof value.then is "function"
      value.then (value) -> localStorage.setItem "#{PREFIX}:#{key}",
        JSON.stringify value
    else localStorage.setItem "#{PREFIX}:#{key}", JSON.stringify value


  cache.remove = (key) -> localStorage.removeItem "#{PREFIX}:#{key}"


  cache.removeAll = -> localStorage.clear()


  cache


LocalStorageCache.$inject = ["$cacheFactory"]
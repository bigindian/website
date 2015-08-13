Promise = require "bluebird"

exports = module.exports = (Stories, Cache) ->
  controller = (request, response, next) ->
    CacheKey = "route:api/news/categories/counters"
    CacheTimeout = 1 * 5 # 5min

    # First check our cache to see if the counters have been saved.
    Cache.get CacheKey

    # If nothing in the cache was found, then the function throws an error. We
    # catch it here and re-fill the cache by calculating the counters again..
    .catch ->

      Stories.getCategoryCount()

      # Once the categories have been fetched, we set it back into the cache
      # and return the output to the user
      .then (counters) ->
        json = JSON.stringify counters, null, 2
        Cache.set CacheKey, json, CacheTimeout

    # This promise only executes when the counters have been fetched (either
    # from the DB or from the cache)
    .then (results) ->
      response.contentType "application/json"
      response.end results

    # Error handler
    .catch next


exports["@singleton"] = true
exports["@require"] = [
  "models/news/stories"
  "libraries/cache"
]

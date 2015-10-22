Backbone = module.exports = ($http, LocalCache, _) ->
  isUndefined = _.isUndefined

  methodMap =
    create: "POST"
    delete: "DELETE"
    patch: "PATCH"
    read: "GET"
    update: "PUT"

  sync = (method, model, options) ->
    # Default options to empty object
    if isUndefined options then options = {}

    # If cache was set then we set a flag to $http to use our custom
    # localStorage for cache.
    if @cache then options.cache = LocalCache

    httpMethod = options.method or methodMap[method]
    params = method: httpMethod
    if not options.url then params.url = _.result model, "url"

    if isUndefined options.data and
    model and (httpMethod == "POST" or httpMethod == "PUT" or
    httpMethod == "PATCH")
      params.data = JSON.stringify options.attrs or model.toJSON options

    # AngularJS $http doesn"t convert data to querystring for GET method
    if httpMethod == "GET" and not isUndefined options.data
      params.params = options.data

    xhr = ajax _.extend params, options
    .success (data, status, headers, config) ->
      options.xhr =
        config: config
        headers: headers
        status: status
      if not isUndefined options.success and
      _.isFunction options.success then options.success data

    .error (data, status, headers, config) ->
      options.xhr =
        config: config
        headers: headers
        status: status
      if not isUndefined options.error and
      _.isFunction options.error then options.error data


    model.trigger "request", model, xhr, _.extend params, options
    xhr


  ajax = -> $http.apply $http, arguments


  ###
    To make Backbone work properly with AngularJS, we override Backbone's sync
    and ajax methods.
  ###
  _.extend window.Backbone, sync: sync, ajax: ajax


Backbone.$inject = [
  "$http"
  "@cache"
  "underscore"
]
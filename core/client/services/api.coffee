ApiService = module.exports = ($log, $http, $q, Environment) ->
  _url = (relativeURL) -> "#{Environment.url}/api#{relativeURL}"


  class Api
    constructor: (options={}) ->
      {@baseUrl="", @model, @collection} = options
      if options.postRequest then @postRequest = options.postRequest

    url: (path) -> "#{Environment.url}/api#{@baseUrl}#{path}"

    postRequest: (model) -> model
    preRequest: (options) -> options

    _getXhrOptions: (method, url="", options={}) ->
      options.url = @url url
      options.method = method
      options

    _parseModelorCollection: (data) ->
      if Array.isArray data then new @collection data
      else new @model data


    get: (url, options={}) ->
      $http @preRequest @_getXhrOptions "GET", url, options
      .then (response) => @postRequest @_parseModelorCollection response.data

    put: (url, body, options={}) ->
      options.body = body
      $http @preRequest @_getXhrOptions "PUT", url, options
      .then (response) => @postRequest @_parseModelorCollection response.data

    post: (url, body, options) ->
      options.body = body
      $http @preRequest @_getXhrOptions "POST", url, options
      .then (response) => @postRequest @_parseModelorCollection response.data

    delete: (url, body, options) ->
      options.body = body
      $http @preRequest @_getXhrOptions "DELETE", url, options
      .then (response) => @postRequest @_parseModelorCollection response.data


ApiService.tag = "service:api"
ApiService.$inject = [
  "$log"
  "$http"
  "$q"
  "@environment"
]
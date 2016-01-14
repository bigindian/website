ApiService = module.exports = ($log, $http, $q, Environment) ->
  _url = (relativeURL) -> "#{Environment.url}/api#{relativeURL}"

  _getXhrOptions = (method, url="", options={}) ->
    options.url = _url url
    options.method = method
    options

  class Api
    @get: (url, options={}) ->
      $http _getXhrOptions "GET", url, options

    @put: (url, body, options={}) ->
      options.body = body
      $http _getXhrOptions "PUT", url, options

    @post: (url, body, options={}) ->
      options.body = body
      $http _getXhrOptions "POST", url, options

    @delete: (url, body, options={}) ->
      options.body = body
      $http _getXhrOptions "DELETE", url, options


ApiService.tag = "service:api"
ApiService.$inject = [
  "$log"
  "$http"
  "$q"
  "@environment"
]
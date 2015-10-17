Model = module.exports = ($http, $log, Environment) ->
  logger = $log.init Model.tag
  logger.log "initializing"

  new class
    top: ->
      API = "#{Environment.url}/api/news/top"
      logger.log "fetching top news stories from server by id"
      $http.get "#{API}"


    create: (data, headers={}) ->
      $http
        data: data
        headers: headers
        method: "POST"
        url: "#{Environment.url}/api/news/stories"


    update: (id, data, headers={}) ->
      $http
        data: data
        headers: headers
        method: "PUT"
        url: "#{Environment.url}/api/news/stories/#{id}"


    upvote: (id) ->
      $http
        method: "PUT"
        url: "#{Environment.url}/api/news/stories/#{id}/upvote"


    createComment: (id, data, headers={}) ->
      $http
        data: data
        headers: headers
        method: "POST"
        url: "#{Environment.url}/api/news/stories/#{id}/comments"


Model.tag = "model:news/stories"
Model.$inject = [
  "$http"
  "$log"
  "@environment"
  "@storage"
]
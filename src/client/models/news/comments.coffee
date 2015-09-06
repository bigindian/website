Model = ($http, $log, Environment) ->
  logger = $log.init Model.tag
  logger.log "initializing"

  new class
    upvote: (id) ->
      $http
        method: "PUT"
        url: "#{Environment.url}/api/news/comments/#{id}/upvote"

    createChildComment: (id, data, headers={}) ->
      $http
        data: data
        headers: headers
        method: "POST"
        url: "#{Environment.url}/api/news/comments/#{id}/children"


Model.tag = "model:news/comments"
Model.$inject = [
  "$http"
  "$log"
  "@environment"
  "@storage"
]
module.exports = Model
Model = ($http, $log, Environment) ->
  logger = $log.init Model.tag
  logger.log "initializing"

  serialize = (obj) ->
    str = []
    for p of obj
      if obj.hasOwnProperty(p)
        str.push encodeURIComponent(p) + '=' + encodeURIComponent(obj[p])
    str.join '&'


  new class NewsModel
    search: (queryObject={}) ->
      API = "#{Environment.url}/api/news?#{serialize queryObject}"
      $http.get "#{API}"


Model.tag = "model:news"
Model.$inject = [
  "$http"
  "$log"
  "@environment"
  "@storage"
]
module.exports = Model
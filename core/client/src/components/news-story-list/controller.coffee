Controller =  module.exports = ($scope, $log, $timeout, Api, Articles) ->
  logger = $log.init Controller.tag
  logger.log "initializing"

  articles = null

  $scope.expand = ->
    articles.more = true
    $scope.$emit "packery.reload"

Controller.tag = "component:news-list"
Controller.$inject = [
  "$scope"
  "$log"
  "$timeout"
  "@api"
  "@models/news/articles"
]
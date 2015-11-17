Controller =  module.exports = ($scope, $log, $timeout, Api, Articles) ->
  logger = $log.init Controller.tag
  logger.log "initializing"

  articles = null

  $scope.$watch "_original", (value) ->
    if value not instanceof Articles.Collection
      articles = $scope.articles = new Articles.Collection value
    else articles = $scope.articles = value

    setTimeout (-> $scope.$emit "packery.reload"), 500


  $scope.updateArticles = ->
    articles.update().finally ->
      $scope.$emit "packery.reload"

      # Unset the flag after 0.5s so that the user doesn't miss the 'updating'
      # message.
      $timeout(500).then -> articles.updating = false


  $scope.getFeed = (id) -> ($scope.feeds.where(id: id) or [])[0]


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
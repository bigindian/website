Controller =  module.exports = ($scope, $log, $timeout, Feeds) ->
  logger = $log.init Controller.tag
  logger.log "initializing"

  feed = null

  $scope.$watch "_original", (value) ->
    if value not instanceof Feeds.Model
      feed = $scope.feed = new Feeds.Model value
    else feed = $scope.feed = value

    setTimeout (-> $scope.$emit "packery.reload"), 500


  $scope.updateArticles = ->
    feed.articles.update().finally ->
      $scope.$emit "packery.reload"

      # Unset the flag after 0.5s so that the user doesn't miss the 'updating'
      # message.
      $timeout(500).then -> feed.updating = false


Controller.tag = "component:news-feed"
Controller.$inject = [
  "$scope"
  "$log"
  "$timeout"
  "@models/news/feeds"
]
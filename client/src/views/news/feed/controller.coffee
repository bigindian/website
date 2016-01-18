Controller = module.exports = ($cookies, $http, $log, $scope, $storage, Feeds) ->
  logger = $log.init Controller.tag
  logger.log "initializing"
  $scope.$emit "page:initialize"

  # Fetch data from the page.
  $http.pageAsJSON().success (data) ->
    $scope.feed = new Feeds.Model data
    $scope.$emit "page:start"


Controller.tag = "page:news/feed"
Controller.$inject = [
  "$cookies"
  "$http"
  "$log"
  "$scope"
  "@storage"
  "@models/news/feeds"
]
Controller = module.exports = ($http, $log, $scope, $storage, Notifications, Articles, Feeds) ->
  logger = $log.init Controller.tag
  logger.log "initializing"
  $scope.$emit "page:initialize", showSideHeader: true

  # Notifications.warn "Is this your first time here? <a href='/info/tutorial'>Let's get you started</a>", 10 * 1000

  # Fetch data from the page.
  $http.pageAsJSON().success (data) ->
    $scope.feeds = new Feeds.Collection data.feeds
    $scope.recent = new Articles.Collection data.recent,
      updateUrl: "/news/articles?limit=10"
    $scope.top = new Articles.Collection data.top,
      updateUrl: "/news/articles?top=true&limit=15"

    # $scope.pagination = data.pagination
    # $scope.stories = new Stories.Collection data.collection, parse: true
    $scope.$emit "page:start"
    $scope.$emit "page:feeds", data.feeds
    setTimeout (-> $scope.$broadcast "packery.reload"), 1000


Controller.tag = "page:news/index"
Controller.$inject = [
  "$http"
  "$log"
  "$scope"
  "@storage"
  "@notifications"
  "@models/news/articles"
  "@models/news/feeds"
]
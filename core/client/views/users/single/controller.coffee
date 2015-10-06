Controller = module.exports = ($scope, $log, $http) ->
  logger = $log.init Controller.tag
  logger.log "initializing"
  $scope.$emit "page:initialize"


  $http.pageAsJSON().success (data) ->
    data.count =
      views: 100000 * Math.random()
      stories: 100000 * Math.random()
      forumPosts: 100000 * Math.random()
      sharing: 100 * Math.random()

    $scope.user = data
    $scope.$emit "page:start"


Controller.tag = "users/single"
Controller.$inject = [
  "$scope"
  "$log"
  "$http"
]
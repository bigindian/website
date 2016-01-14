Controller = module.exports = ($http, $log, $scope, Stories) ->
  logger = $log.init Controller.tag
  logger.log "initializing"
  $scope.$emit "page:initialize"

  $http.pageAsJSON().success (data) ->
    $scope.stories = new Stories.Collection data
    $scope.$emit "page:start"


Controller.tag = "page:news/index"
Controller.$inject = [
  "$http"
  "$log"
  "$scope"
  "@models/news/stories"
]
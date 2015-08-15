Controller = ($http, $log, $scope) ->
  logger = $log.init Controller.tag
  logger.log "initializing"
  $scope.$emit "page:initialize"
  $scope.$emit "page:start"

  $scope.story = {}

  $http.pageAsJSON().success (data) ->
    $scope.pagination = data.pagination
    $scope.stories = data.collection
    $scope.$emit "page:start"


Controller.tag = "page:news/recent"
Controller.$inject = [
  "$http"
  "$log"
  "$scope"
]

module.exports = Controller
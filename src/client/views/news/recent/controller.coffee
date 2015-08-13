exports = module.exports = ($scope, $log, $controller, $http) ->
  a = $controller "news/categories", $scope: $scope
  console.log a
  name = "[page:news/single]"
  $log.log name, "initializing"
  $scope.$emit "page:loaded"

  $scope.story = {}

  $http.pageAsJSON().success (data) ->
    $scope.pagination = data.pagination
    $scope.stories = data.collection
    $scope.$emit "page:loaded"


exports.$inject = [
  "$scope"
  "$log"
  "$controller"

  "$http"
]

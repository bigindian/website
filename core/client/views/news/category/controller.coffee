Controller = module.exports = ($cookies, $http, $log, $scope, $storage) ->
  logger = $log.init Controller.tag
  logger.log "initializing"
  $scope.$emit "page:initialize"

  # Fetch data from the page.
  $http.pageAsJSON().success (data) ->
    $scope.pagination = data.pagination
    $scope.stories = data.collection
    $scope.$emit "page:start"


Controller.tag = "page:news/category"
Controller.$inject = [
  "$cookies"
  "$http"
  "$log"
  "$scope"
  "@storage"
]
Controller = module.exports = ($http, $log, $location, $scope, $stateParams, Stories) ->
  logger = $log.init Controller.tag
  logger.log "initializing"
  $scope.$emit "page:initialize"

  $scope.page = page = Number $stateParams.page or 1

  $http.pageAsJSON().success (data) ->
    $scope.stories = new Stories.Collection data.docs
    $scope.data = data

    $scope.totalPages = Math.ceil data.total / data.limit

    $scope.next = -> $location.path "/page/#{ page + 1}"
    $scope.prev = -> $location.path "/page/#{ page - 1}"

    $scope.$emit "page:start"


Controller.tag = "page:news/index"
Controller.$inject = [
  "$http"
  "$log"
  "$location"
  "$scope"
  "$stateParams"
  "@models/news/stories"
]
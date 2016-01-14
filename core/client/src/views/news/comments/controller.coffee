Controller = module.exports = ($http, $log, $scope, Comments) ->
  logger = $log.init Controller.tag
  logger.log "initializing"
  $scope.$emit "page:initialize"

  # Fetch data from the page.
  $http.pageAsJSON().success (comments) ->
    $scope.comments = new Comments.Collection comments
    $scope.$emit "page:start"


Controller.tag = "page:news/index"
Controller.$inject = [
  "$http"
  "$log"
  "$scope"
  "@models/news/comments"
]
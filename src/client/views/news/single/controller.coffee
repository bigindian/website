Controller = ($http, $location, $log, $sce, $scope, Stories) ->
  logger = $log.init Controller.tag
  logger.log "initializing"
  $scope.$emit "page:initialize"
  $scope.$emit "page:start"

  $scope.story = {}

  $http.pageAsJSON().success (data) ->
    $scope.story = data.story
    $scope.description = $sce.trustAsHtml $scope.story.description
    $scope.$emit "page:start"


  blockForm = -> $scope.formClasses = loading: $scope.formLoading = true
  unlockForm = -> $scope.formClasses = loading: $scope.formLoading = false


  $scope.submit = (data) ->
    blockForm()
    Stories.createComment $scope.story.id, content: data
    .then ->
      $location.search _success: "comment_posted"
      location.reload() # avoid using global fn.
    .finally unlockForm



Controller.tag = "page:news/single"
Controller.$inject = [
  "$http"
  "$location"
  "$log"
  "$sce"
  "$scope"
  "@models/news/stories"
]
module.exports = Controller
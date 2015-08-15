Controller = ($scope, $log, $notifications, $http, $sce, Stories) ->
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
      $notifications.success "Your comment has been posted successfully! Reload this page"
      location.reload() # avoid using global fn.
    .finally unlockForm



Controller.tag = "page:news/single"
Controller.$inject = [
  "$http"
  "$log"
  "$sce"
  "$scope"

  "@notifications"
  "@models/news/stories"
]


module.exports = Controller
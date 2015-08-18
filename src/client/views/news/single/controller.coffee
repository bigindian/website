Controller = ($http, $log, $sce, $scope, Notifications, Stories) ->
  logger = $log.init Controller.tag
  logger.log "initializing"
  $scope.$emit "page:initialize"
  $scope.$emit "page:start"

  $scope.story = {}

  downloadPage = ->
    $http.pageAsJSON().success (data) ->
      $scope.story = data.story or {}
      $scope.description = $sce.trustAsHtml $scope.story.description
      $scope.$emit "page:start"
      $scope.$emit "page:modify", title: $scope.story.title

  downloadPage()


  blockForm = -> $scope.formClasses = loading: $scope.formLoading = true
  unlockForm = -> $scope.formClasses = loading: $scope.formLoading = false


  $scope.submit = (data) ->
    blockForm()
    Stories.createComment $scope.story.id, content: data
    .then ->
      Notifications.success "comment_posted"
      downloadPage()
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
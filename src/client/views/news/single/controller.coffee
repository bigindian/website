Controller = ($http, $log, $sce, $scope, Notifications, Stories) ->
  logger = $log.init Controller.tag
  logger.log "initializing"

  $scope.$emit "page:initialize"
  $scope.$emit "page:start"

  $scope.story = {}
  $scope.comment = ""

  downloadPage = ->
    $http.pageAsJSON().success (data) ->
      $scope.story = data.story or {}
      $scope.description = $sce.trustAsHtml $scope.story.description
      $scope.$emit "page:start"
      $scope.$emit "page:modify", title: $scope.story.title
  downloadPage()


  blockForm = -> $scope.formClasses = loading: $scope.formLoading = true
  unlockForm = -> $scope.formClasses = loading: $scope.formLoading = false


  $scope.submit = ->
    blockForm()
    Stories.createComment $scope.story.id, content: $scope.story.comment
    .then ->
      logger.log "comment posted!"
      $scope.story.comment = ""

      downloadPage()
      Notifications.success "comment_posted"
    .catch (error) -> logger.error error
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
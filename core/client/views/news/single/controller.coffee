Controller = module.exports = ($http, $location, $log, $sce, $scope, Notifications, Stories, Comments) ->
  logger = $log.init Controller.tag
  logger.log "initializing"

  $scope.$emit "page:initialize"
  $scope.$emit "page:start"

  $scope.data = {}
  $scope.story = {}
  $scope.comment = ""

  $location.hash ""

  _blockForm = -> $scope.formClasses = loading: $scope.formLoading = true
  _unlockForm = -> $scope.formClasses = loading: $scope.formLoading = false


  $scope.submit = ->
    _blockForm()

    id = $scope.story.id
    body = content: $scope.story.comment
    headers = "x-recaptcha": $scope.data.gcaptcha

    Stories.createComment id, body, headers
    .success (comment) ->
      logger.log "comment posted!"
      $scope.story.comment = ""

      $location.search "comment", comment.slug

      $scope.$emit "refresh"
      Notifications.success "comment_posted"

    .catch (error) -> logger.error error
    .finally _unlockForm


  $scope.$emit "page:start"
  downloadPage = ->
    $http.pageAsJSON().success (data) ->
      $scope.story = new Stories.Model data.story, parse: true
      $scope.comments = new Comments.Collection data.story.comments, parse: true

      $scope.$emit "page:modify", title: $scope.story.get "title"

  $scope.$on "refresh", downloadPage
  downloadPage()


Controller.tag = "page:news/single"
Controller.$inject = [
  "$http"
  "$location"
  "$log"
  "$sce"
  "$scope"
  "@notifications"
  "@models/news/stories"
  "@models/news/comments"
]
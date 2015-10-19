Controller = module.exports = ($anchorScroll, $location, $log, $sce, $scope, $timeout, Notifications, Comments, Users) ->
  logger = $log.init Controller.tag
  logger.log "initializing"

  $scope.$watch "comment.content_markdown", (value) ->
    $scope.markdown = $sce.trustAsHtml $scope.comment.content

  window.a = $scope
  $scope.data = {}
  $scope.path = $location.path()


  onLocationChange = ->
    if $scope.comment
      if $location.search().comment == $scope.comment.slug
        $scope.comment.focus = true
        $timeout(500).then ->
          $location.hash "comment_#{$scope.comment.slug}"
          $anchorScroll()

      else $scope.comment.focus = false
  $scope.$on "$locationChangeSuccess", onLocationChange
  $scope.$watch "comment", onLocationChange
  onLocationChange()


  $scope.upvote = ->
    # Ensure user is logged in!
    Users.withLogin(redirect: true).then ->
      # Avoid upvoting if the comment has already been voting
      if $scope.hasVoted then return else $scope.hasVoted = true

      # Post comment into the DB
      Comments.upvote $scope.comment.id
      .then -> $scope.comment.votes_count += 1


  $scope.toggleReportBox = -> Users.withLogin(redirect: true).then ->
    $scope.data.showReportBox = !$scope.data.showReportBox


  $scope.toggleReplyBox = -> Users.withLogin(redirect: true).then ->
    $scope.data.showReplyBox = !$scope.data.showReplyBox


  blockForm = -> $scope.formClasses = loading: $scope.formLoading = true
  unlockForm = -> $scope.formClasses = loading: $scope.formLoading = false


  # Submit a new child comment to this one
  $scope.submitComment = ->
    blockForm()

    id = $scope.comment.id
    body = content: $scope.data.child_comment
    headers = "x-recaptcha": $scope.data.gcaptcha

    Comments.createChildComment id, body, headers
    .then ->
      logger.log "comment posted!"
      $scope.story.comment = ""

      $scope.$emit "refresh"
      Notifications.success "comment_posted"
    .catch (error) -> logger.error error
    .finally unlockForm


  # Submit a new report for this comment


Controller.tag = "component:news-comment"
Controller.$inject = [
  "$anchorScroll"
  "$location"
  "$log"
  "$sce"
  "$scope"
  "$timeout"
  "@notifications"
  "@models/news/comments"
  "@models/users"
]
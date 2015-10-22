Controller = module.exports = ($anchorScroll, $location, $log, $sce, $scope, $timeout, Notifications, Comments, Session) ->
  logger = $log.init Controller.tag
  $scope.data = {}
  $scope.path = $location.path()
  logger.log "initializing"


  $scope.$watch "_original", (value={}) ->
    if value.toJSON? then $scope.comment = value
    else $scope.comment = new Comments.Model value, parse: true


  updateComment = (comment) ->
    $scope.commentJSON = comment.toJSON()
    $scope.childComments = new Comments.Collection comment.get "children", parse: true
    $scope.markdown = $sce.trustAsHtml comment.get "content"
    onLocationChange()
  $scope.$watch "comment", updateComment


  onLocationChange = ->
    if $scope.comment
      if $location.search().comment == $scope.commentJSON.slug
        $scope.commentJSON.focus = true
        $timeout(500).then ->
          $location.hash "comment_#{$scope.commentJSON.slug}"
          $anchorScroll()

      else $scope.commentJSON.focus = false
  $scope.$on "$locationChangeSuccess", onLocationChange



  $scope.setCollapse = (set) -> $scope.collapse = set


  $scope.upvote = ->
    Session.ensureLogin(redirect: true).then ->
      # Avoid upvoting if the comment has already been voting
      if $scope.commentJSON.voted then return

      # Post comment into the DB
      $scope.comment.upvote()
      .finally -> updateComment $scope.comment


  $scope.toggleReportBox = -> Session.ensureLogin(redirect: true).then ->
    $scope.data.showReportBox = !$scope.data.showReportBox


  $scope.toggleReplyBox = -> Session.ensureLogin(redirect: true).then ->
    $scope.data.showReplyBox = !$scope.data.showReplyBox


  blockForm = -> $scope.formClasses = loading: $scope.formLoading = true
  unlockForm = -> $scope.formClasses = loading: $scope.formLoading = false


  # Submit a new child comment to this one
  $scope.submitComment = ->
    blockForm()

    id = $scope.comment.id
    body =
      content_markdown: $scope.data.child_comment
      gcaptcha: $scope.data.gcaptcha

    $scope.comment.createChild body
    # Comments.createChildComment id, body, headers
    .then ->
      logger.log "comment posted!"

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
  "@models/session"
]
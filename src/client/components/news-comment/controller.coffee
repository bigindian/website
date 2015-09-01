Controller = ($location, $log, $sce, $scope, Notifications, Comments, Users) ->
  logger = $log.init Controller.tag
  logger.log "initializing"

  $scope.$watch "comment.content_markdown", (value) ->
    $scope.markdown = $sce.trustAsHtml $scope.comment.content


  $scope.upvote = ->
    #! User needs to be logged in
    if not Users.isLoggedIn()
      Notifications.warn "login_needed"
      return $location.path "/login"

    #! Avoid upvoting if the comment has already been voting
    if $scope.hasVoted then return else $scope.hasVoted = true

    $scope.comment.score += 1
    Comments.upvote $scope.comment.id


Controller.tag = "component:news-comment"
Controller.$inject = [
  "$location"
  "$log"
  "$sce"
  "$scope"
  "@notifications"
  "@models/news/comments"
  "@models/users"
]
module.exports = Controller
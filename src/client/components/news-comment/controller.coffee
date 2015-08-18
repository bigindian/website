exports = module.exports = ($scope, $log, $sce, Comments) ->
  tag = "[component:news-comment]"
  $log.log tag, "initializing"

  $scope.$watch "comment.content_markdown", (value) ->
    $scope.markdown = $sce.trustAsHtml $scope.comment.content

  $scope.upvote = ->
    if $scope.hasVoted then return
    $scope.hasVoted = true
    $scope.story.score += 1
    Comments.upvote $scope.comment.id


exports.$inject = [
  "$scope"
  "$log"
  "$sce"
  "@models/news/comments"
]
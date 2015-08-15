exports = module.exports = ($scope, $log, $sce) ->
  tag = "[component:news-comment]"
  $log.log tag, "initializing"

  $scope.$watch "comment.content_markdown", (value) ->
    $scope.markdown = $sce.trustAsHtml $scope.comment.content

  $scope.upvote = ->
    if $scope.hasVoted then return
    $scope.hasVoted = true
    $scope.story.score += 1
    Stories.upvote $scope.story.id


exports.$inject = [
  "$scope"
  "$log"
  "$sce"
]
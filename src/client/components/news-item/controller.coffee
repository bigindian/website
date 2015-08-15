exports = module.exports = ($scope, $log, Stories) ->
  tag = "[component:news-item]"
  $log.log tag, "initializing"

  $scope.hasVoted = false
  $scope.upvote = ->
    if $scope.hasVoted then return
    $scope.story.score += 1
    $scope.hasVoted = true
    Stories.upvote $scope.story.id


exports.$inject = [
  "$scope"
  "$log"
  "models.news.stories"
]
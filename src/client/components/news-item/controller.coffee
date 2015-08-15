Controller = ($scope, $log, Stories) ->
  logger = $log.init Controller.tag
  logger.log "initializing"

  $scope.hasVoted = false
  $scope.upvote = ->
    if $scope.hasVoted then return
    $scope.story.score += 1
    $scope.hasVoted = true
    Stories.upvote $scope.story.id


Controller.tag = "component:news-item"
Controller.$inject = [
  "$scope"
  "$log"
  "@models/news/stories"
]
module.exports = Controller
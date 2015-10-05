Controller = ($scope, $location, $log, Notifications, Stories, Categories, Users, Settings) ->
  logger = $log.init Controller.tag
  logger.log "initializing"

  $scope.settings = {}
  $scope.getCategory = (id) -> Categories.findById id

  $scope.$watch "story", (story={}) ->
    categories = []

    for categoryPair in (story.categories or [])
      categories.push Categories.findById categoryPair.category
    $scope.story.parsedCategories = categories


  onSettingsUpdate = ->
    $scope.settings = Settings.getAll()
    $scope.openNewTab = Settings.get "storyInNewTab"


  $scope.$on "settings:change", onSettingsUpdate
  onSettingsUpdate()

  # $scope.categories = Categories.getAll()
  $scope.hasVoted = false
  $scope.upvote = ->
    #! User needs to be logged in
    if not Users.isLoggedIn()
      $location.path "/login"
      Notifications.warn "login_needed"

    #! Avoid upvoting if the comment has already been voting
    if $scope.hasVoted then return

    $scope.story.score += 1
    $scope.hasVoted = true
    Stories.upvote $scope.story.id


Controller.tag = "component:news-item"
Controller.$inject = [
  "$scope"
  "$location"
  "$log"
  "@notifications"
  "@models/news/stories"
  "@models/news/categories"
  "@models/users"
  "@settings"
]
module.exports = Controller
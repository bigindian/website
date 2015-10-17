Controller = ($sce, $scope, $location, $log, Notifications, Stories, Users, Categories, Settings) ->
  logger = $log.init Controller.tag
  logger.log "initializing"

  $scope.settings = {}
  $scope.data = {}

  onSettingsUpdate = ->
    $scope.settings = Settings.getAll()
    $scope.openNewTab = Settings.get "storyInNewTab"

  $scope.setEditMode = (set) -> $scope.editMode = set

  $scope.getCategory = (id) -> Categories.findById id

  $scope.$watch "story", (story={}) ->
    $scope.story.description = $sce.trustAsHtml $scope.story.description
    $scope.story.parsedCategories = do ->
      Categories.findById c for c in (story.meta.categories or [])


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

    $scope.story.votes_count += 1
    $scope.hasVoted = true
    Stories.upvote $scope.story.id


Controller.tag = "component:news-item"
Controller.$inject = [
  "$sce"
  "$scope"
  "$location"
  "$log"
  "@notifications"
  "@models/news/stories"
  "@models/users"
  "@models/news/categories"
  "@settings"
]
module.exports = Controller
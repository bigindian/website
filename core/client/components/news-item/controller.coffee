Controller =  module.exports = ($sce, $scope, $location, $log, Notifications, Stories, Users, Categories, Settings) ->
  logger = $log.init Controller.tag
  logger.log "initializing"

  # Initialize defaults!
  $scope.settings = {}
  $scope.data = {}
  $scope.edit = {}
  $scope.hasVoted = false

  currentUser = Users.getCurrent()

  # This function runs everytime the story gets updated!
  $scope.$watch "story", (story={}) ->
    $scope.edit.description_markdown = $scope.story.description_markdown
    $scope.edit.title = $scope.story.title

    $scope.userCanEdit = $scope.story.created_by is currentUser.id or
      currentUser.isModerator() or currentUser.isAdmin()

    $scope.story.description = $sce.trustAsHtml $scope.story.description
    $scope.story.parsedCategories = do ->
      Categories.findById c for c in story.meta.categories or []


  # Add a listener for whenever settings change
  onSettingsUpdate = ->
    $scope.settings = Settings.getAll()
    $scope.openNewTab = Settings.get "storyInNewTab"
  $scope.$on "settings:change", onSettingsUpdate
  onSettingsUpdate()


  # Helper function to set the edit mode for the story. We have to do this
  # because directly setting this variable causes some bugs with the ng-if's
  $scope.setEditMode = (set) -> $scope.editMode = set


  $scope.upvote = ->
    #! Avoid upvoting if the comment has already been voting
    if $scope.hasVoted then return

    Users.withLogin(redirect: true).then ->
      Stories.upvote($scope.story.id).then ->
        $scope.story.votes_count += 1
      .finally -> $scope.hasVoted = true


  blockForm = -> $scope.formClasses = loading: $scope.formLoading = true
  unlockForm = -> $scope.formClasses = loading: $scope.formLoading = false


  $scope.updateStory = ->
    blockForm()
    body = $scope.edit
    headers = "x-recaptcha": $scope.data.gcaptcha

    Users.withLogin(redirect: true).then ->
      Stories.update $scope.story.id, body, headers
      .then ->
        $scope.setEditMode false
        $scope.$emit "refresh"
      .finally unlockForm


  # Submit a new comment to the story!
  $scope.submitComment = ->
    blockForm()

    id = $scope.story.id
    body = content: $scope.story.comment
    headers = "x-recaptcha": $scope.data.gcaptcha

    Stories.createComment id, body, headers
    .success (comment) ->
      logger.log "comment posted!"

      # Erase the comment..
      $scope.story.comment = ""
      $scope.data.gcaptcha = null

      # focus on the comment!
      $location.search "comment", comment.slug

      # Refresh the page and show the comment posted notification!
      $scope.$emit "refresh"
      Notifications.success "comment_posted"

    .catch (error) -> logger.error error
    .finally unlockForm


  # $scope.

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
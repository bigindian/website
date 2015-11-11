Controller =  module.exports = ($sce, $element, $scope, $location, $log, $timeout, angular, Notifications, Stories, Session, Categories, Settings) ->
  logger = $log.init Controller.tag
  logger.log "initializing"

  # Initialize defaults!
  $scope.settings = {}
  $scope.data = {}
  $scope.edit = {}
  $scope.story = {}

  $scope.$watch "_original", (value={}) ->
    if value.toJSON? then $scope.story = value
    else $scope.story = new Stories.Model value, parse: true
    $scope.storyJSON = $scope.story.toJSON()

    $scope.story.on "change", -> updateStory $scope.story
    updateStory $scope.story


  # This function runs everytime the story gets updated!
  updateStory = (story) ->
    if not story? then return
    currentUser = Session.user

    $timeout(500).then ->
      queryResult = $element[0].querySelector ".details"
      wrappedQueryResult = angular.element queryResult
      $scope.height = wrappedQueryResult[0].offsetHeight or 100

    $scope.edit.description_markdown = story.get "description_markdown"
    $scope.edit.title = story.get "title"

    # $scope.userCanEdit = $scope.story.created_by is currentUser.id or
    #   currentUser.isModerator() or currentUser.isAdmin()
    $scope.categories = do ->
      for category in $scope.storyJSON.categories
        Categories.collection().findWhere(id: category).toJSON()

    $scope.storyJSON.description = $sce.trustAsHtml story.get "description"


  # Add a listener for whenever settings change
  onSettingsUpdate = ->
    $scope.settings = Settings.getAll()
    $scope.openNewTab = Settings.get "storyInNewTab"
  $scope.$on "settings:change", onSettingsUpdate
  onSettingsUpdate()


  # Helper function to set the edit mode for the story. We have to do this
  # because directly setting this variable causes some bugs with the ng-if's
  $scope.setEditMode = (set) -> $scope.editMode = set

  # Same function as above, but for the report mode.
  $scope.setReportMode = (set) -> $scope.reportMode = set


  $scope.upvote = ->
    # Avoid upvoting if the comment has already been voting
    if $scope.storyJSON.voted then return
    Session.ensureLogin(redirect: true).then ->
      $scope.story.upvote().finally -> updateStory $scope.story


  blockForm = -> $scope.formClasses = loading: $scope.formLoading = true
  unlockForm = -> $scope.formClasses = loading: $scope.formLoading = false


  $scope.updateStory = ->
    blockForm()
    body = $scope.edit
    headers = "x-recaptcha": $scope.data.gcaptcha

    Session.ensureLogin(redirect: true).then ->
      Stories.update $scope.story.id, body, headers
      .then ->
        $scope.setEditMode false
        $scope.$emit "refresh"
      .finally unlockForm


  # Submit a new comment to the story!
  $scope.submitComment = ->
    blockForm()

    id = $scope.story.id
    body =
      content_markdown: $scope.data.comment
      gcaptcha: $scope.data.gcaptcha

    $scope.story.createComment body
    .then (comment) ->
      logger.log "comment posted!"

      # Erase the comment..
      $scope.data.comment = ""
      $scope.data.gcaptcha = null

      # focus on the comment!
      $location.search "comment", comment.slug

      # Refresh the page and show the comment posted notification!
      $scope.$emit "refresh"
      Notifications.success "comment_posted"

    .catch (error) -> logger.error error
    .finally unlockForm


  $scope.submitReport = ->
    blockForm()

    $scope.story.report $scope.data.report
    .then (comment) ->
      logger.log "report posted!"

      # Erase the report
      $scope.data.report = {}
      $scope.setReportMode false

      # Refresh the page and show the report posted notification!
      $scope.$emit "refresh"
      Notifications.success "report_posted"

    .catch (error) -> logger.error error
    .finally unlockForm


Controller.tag = "component:news-item"
Controller.$inject = [
  "$sce"
  "$element"
  "$scope"
  "$location"
  "$log"
  "$timeout"
  "angular"
  "@notifications"
  "@models/news/stories"
  "@models/session"
  "@models/news/categories"
  "@settings"
]
Controller =  module.exports = ($sce, $element, $scope, $location, $log, $timeout, angular, Notifications, Stories, Session, Categories, Settings) ->
  logger = $log.init Controller.tag
  logger.log "initializing"

  # Initialize defaults!
  $scope.settings = {}
  $scope.data = {}
  $scope.edit = {}
  $scope.story = {}

  # This function runs everytime the story gets updated!
  updateStory = (story) ->
    if not story? then return
    currentUser = Session.user
    $scope.edit.description_markdown = story.get "description_markdown"
    $scope.edit.title = story.get "title"

    # $scope.userCanEdit = $scope.story.created_by is currentUser.id or
    #   currentUser.isModerator() or currentUser.isAdmin()
    $scope.categories = do ->
      for category in $scope.storyJSON.categories
        Categories.collection().findWhere(id: category).toJSON()

    $scope.storyJSON.description = $sce.trustAsHtml story.get "description"


Controller.tag = "component:news-form"
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
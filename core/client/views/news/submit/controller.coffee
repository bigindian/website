Controller = module.exports = ($http, $location, $log, $scope, Notifications, Stories) ->
  logger = $log.init Controller.tag
  logger.log "initializing"
  $scope.$emit "page:initialize", needLogin: true
  $scope.$emit "page:start"

  $scope.selectedCats = 0

  $scope.story =
    title: $location.search().title or ""
    url: $location.search().url or ""


  blockForm = -> $scope.formClasses = loading: $scope.formLoading = true
  unlockForm = -> $scope.formClasses = loading: $scope.formLoading = false


  # When requested to get the title, send the URL to our scrapper
  $scope.getTitle = ->
    blockForm()
    $http.get "/api/news/scrape?u=#{$scope.story.url}"
    .success (info) -> $scope.story.title = info.title
    .finally unlockForm


  ###
    @param data {Object}
  ###
  $scope.submit = ->
    blockForm()
    logger.log "submitting form"
    logger.debug $scope.story

    headers = "x-recaptcha": $scope.form.gcaptcha

    # Send the request!
    new Stories.Model $scope.story
    .then (story) ->
      Notifications.success "story_submit_success"
      $location.path "/story/#{story.slug}"
    .catch -> Notifications.success "story_submit_fail"
    .finally unlockForm


Controller.tag = "page:news"
Controller.$inject = [
  "$http"
  "$location"
  "$log"
  "$scope"
  "@notifications"
  "@models/news/stories"
]
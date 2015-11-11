Controller = module.exports = ($http, $location, $log, $scope, angular, _, Notifications, Stories, Categories) ->
  logger = $log.init Controller.tag
  logger.log "initializing"
  $scope.$emit "page:initialize", needLogin: true
  $scope.$emit "page:start"

  $scope.data = {}

  $scope.data.story = new Stories.Model
    url: $location.search().url or ""

  story = $scope.data.story

  $scope.categories = Categories.getAllbyIds()

  blockForm = -> $scope.formClasses = loading: $scope.formLoading = true
  unlockForm = -> $scope.formClasses = loading: $scope.formLoading = false


  # When requested to get the title, send the URL to our scrapper
  $scope.checkURL = ->
    blockForm()

    $http.get "/api/news/scrape?u=#{encodeURIComponent story.get 'url'}"
    .success (info) ->
      story.set "meta", info.meta
      story.set "excerpt", info.excerpt
      story.set "image_url", info.image_url
      story.set "title", $location.search().title or info.title
      $scope.urlValid = true
    .finally unlockForm


  $scope.isCatActive = (id) -> id in story.get "categories"


  $scope.toggleCat = (id) ->
    logger.debug "toggle category with id", id

    categories = story.get "categories"
    if categories.length >= 3 then return

    if id in categories then story.set "categories", _.without categories, id
    else story.set "categories", _.union [id], categories


  story.on "change", (value) -> $scope.storyCopy = value.toJSON()


  $scope.$watch "data.story.$attributes.url", (value) ->
    # $scope.story.set "url", = url: value
    $scope.urlValid = false


  ###
    @param data {Object}
  ###
  $scope.submit = ->
    blockForm()
    logger.log "submitting form"
    logger.debug story

    # Send the request!
    story.save()
    .then (data) ->
      console.log data
      Notifications.success "story_submit_success"
      $location.url "/story/#{story.get 'slug'}"
    .catch -> Notifications.success "story_submit_fail"
    .finally unlockForm


Controller.tag = "page:news"
Controller.$inject = [
  "$http"
  "$location"
  "$log"
  "$scope"
  "angular"
  "underscore"
  "@notifications"
  "@models/news/stories"
  "@models/news/categories"
]
Controller = ($http, $location, $log, $scope, Categories, Stories) ->
  logger = $log.init Controller.tag
  logger.log "initializing"
  $scope.$emit "page:initialize", needLogin: true
  $scope.$emit "page:start"

  $scope.selectedCats = 0
  $scope.story = {}
  $scope.categories = Categories.getAll() or []
  cat.disableLink = true for cat in $scope.categories


  blockForm = -> $scope.formClasses = loading: $scope.formLoading = true
  unlockForm = -> $scope.formClasses = loading: $scope.formLoading = false


  $scope.deselect = (cat) ->
    logger.log "de-selected category"
    logger.debug cat

    cat.select = false
    $scope.selectedCats--


  $scope.select = (cat) ->
    logger.log "selected category"
    logger.debug cat

    cat.select = true
    $scope.selectedCats++


  # When requested to get the title, send the URL to our scrapper
  $scope.getTitle = ->
    blockForm()
    $http.get "/api/news/scrape?u=#{$scope.story.url}"
    .success (info) -> $scope.story.title = info.title
    .finally unlockForm



  ###
    @param data {Object}
  ###
  $scope.submit = (data) ->
    blockForm()
    logger.log "submitting form"
    logger.debug data

    # Get the categories
    data.categories = []
    for category in $scope.categories
      if category.select is true then data.categories.push category.id

    # Send the request!
    Stories.create data
    .success (story) -> $location.path "/story/#{story.slug}"
    .finally unlockForm


Controller.tag = "page:news"
Controller.$inject = [
  "$http"
  "$location"
  "$log"
  "$scope"
  "@models/news/categories"
  "@models/news/stories"
]


module.exports = Controller
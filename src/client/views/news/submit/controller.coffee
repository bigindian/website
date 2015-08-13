Controller = ($scope, $log, $http, $location, Stories, Categories) ->
  name = "[page:news]"
  $log.log name, "initializing"
  $scope.$emit "page:loaded"

  $scope.selectedCats = 0

  $scope.story = {}

  blockForm = -> $scope.formClasses = loading: $scope.formLoading = true
  unlockForm = -> $scope.formClasses = loading: $scope.formLoading = false

  # When requested to get the title, send the URL to our scrapper
  $scope.getTitle = ->
    blockForm()
    $http.get "/api/news/scrape?u=#{$scope.story.url}"
    .success (info) -> $scope.story.title = info.title
    .finally unlockForm


  $scope.categories = Categories.getAll()
  cat.disableLink = true for cat in $scope.categories

  $scope.deselect = (cat) ->
    cat.select = false
    $scope.selectedCats--

  $scope.select = (cat) ->
    cat.select = true
    $scope.selectedCats++

  $scope.submit = (data) ->
    blockForm()
    Stories.create data
    .then -> $location.path "/news/recent"
    .finally unlockForm


Controller.$inject = [
  "$scope"
  "$log"
  "$http"
  "$location"
  "models.news.stories"
  "models.news.categories"
]


module.exports = Controller
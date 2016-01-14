Controller = module.exports = ($location, $log, $scope, $http, $toast, angular, Tags) ->
  logger = $log.init Controller.tag
  logger.log "initializing"
  $scope.$emit "page:initialize" #, needLogin: true
  $scope.$emit "page:start"

  $scope.tags = Tags.Cache.toJSON()
  $scope.selected_tags = []


  $scope.getTitle = ->
    $http.post "/api/news/helpers/fetch_title?url=#{$scope.story.url}"
    .success (data) -> $scope.story.title = data.title



  $scope.onSubmit = ->
    $scope.form.loading = true
    $http.post "/api/news/stories", $scope.story
    .success (story) ->
      modal = $toast.simple()
        .content "Your story has been submitted!"
        .position "top right"
      $toast.show modal
      # $location.url "#{story._id}/#{story}"
      $location.url "/"
    .finally -> $scope.form.loading = false


  # Search for tags.
  $scope.querySearch = (query) =>
    if query then $scope.tags.filter $scope.createFilterFor query else []

  # Create filter function for a query string
  $scope.createFilterFor = (query) ->
    lowercaseQuery = angular.lowercase(query)
    (tag) -> tag.tag.indexOf(lowercaseQuery) == 0


Controller.tag = "page:news"
Controller.$inject = [
  "$location"
  "$log"
  "$scope"
  "$http"
  "$mdToast"
  "angular"
  "@models/news/tags"
]
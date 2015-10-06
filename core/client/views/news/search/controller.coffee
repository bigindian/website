Controller = module.exports = ($location, $log, $scope, News) ->
  logger = $log.init Controller.tag
  logger.log "initializing"
  $scope.$emit "page:initialize"
  $scope.$emit "page:start"

  defaultQuery =
    what: "all"
    order: "rel"

  $scope.query = angular.extend {}, defaultQuery, $location.search()

  $scope.search = ->
    $location.search $scope.query

    News.search($scope.query).success (data) ->
      if data.hits then $scope.results = data.hits
      else $scope.results = false

  $scope.search()



Controller.tag = "page:news/search"
Controller.$inject = [
  "$location"
  "$log"
  "$scope"
  "@models/news"
]
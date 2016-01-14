Controller =  module.exports = ($scope, $location, $mdBottomSheet, $window, $http) ->
  $scope.openLink = ->
    short_id = $scope.model.get "short_id"
    $window.open $scope.model.get("url"), "_blank"
    $http.post "/api/news/stories/#{ $scope.model.id }/open"
    # $location.url "/stories/#{short_id}"

  $scope.openStory = ->
    short_id = $scope.model.get "short_id"
    # $location.url "/stories/#{short_id}"

  $scope.showShareSheet = ($event) ->
    $mdBottomSheet.show
      templateUrl: "components/news-card/template-card"
      targetEvent: $event


Controller.tag = "component:news-card"
Controller.$inject = [
  "$scope"
  "$location"
  "$mdBottomSheet"
  "$window"
  "$http"
]
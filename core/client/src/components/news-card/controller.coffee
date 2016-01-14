Controller =  module.exports = ($scope, $location, $mdBottomSheet, $http) ->
  $scope.openLink = ->
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
  "$http"
]
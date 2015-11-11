Controller =  module.exports = ($scope, Categories) ->
  $scope.$watch "_original", (value) ->
    $scope.model = Categories.collection().findWhere id: value


Controller.tag = "component:news-item"
Controller.$inject = [
  "$scope"
  "@models/news/categories"
]
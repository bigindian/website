Controller =  module.exports = ($scope, $sce, Comments) ->
  $scope.$watch "_original", (value) ->
    if value instanceof Comments.Model then $scope.model = value
    else $scope.model = new Comments.Model value
    $scope.content = $sce.trustAsHtml $scope.model.$attributes.comment


Controller.tag = "component:news-comment"
Controller.$inject = [
  "$scope"
  "$sce"
  "@models/news/comments"
]
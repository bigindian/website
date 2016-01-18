module.exports = DialogController = ($scope, $mdDialog) ->
  $scope.answer = (answer) -> $mdDialog.hide answer
  $scope.cancel = -> $mdDialog.cancel()
  $scope.hide = -> $mdDialog.hide()
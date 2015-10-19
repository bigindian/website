module.exports = (scope, element, attributes, ngModel) ->
  ngModel.$render = -> scope.comment = ngModel.$modelValue or {}
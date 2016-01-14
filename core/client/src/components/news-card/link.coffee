module.exports = (scope, element, attributes, ngModel) ->
  ngModel.$render = -> scope.model = ngModel.$modelValue or {}
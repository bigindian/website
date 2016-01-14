module.exports = (scope, element, attributes, ngModel) ->
  ngModel.$render = -> scope.items = ngModel.$modelValue
module.exports = (scope, element, attributes, ngModel) ->
  ngModel.$render = -> scope._original = ngModel.$modelValue or {}
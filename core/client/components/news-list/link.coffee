module.exports = (scope, element, attributes, ngModel) ->
  ngModel.$render = ->
    scope.title = attributes.title
    scope._original = ngModel.$modelValue
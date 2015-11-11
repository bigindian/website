i = 0
module.exports = (scope, element, attributes, ngModel) ->
  ngModel.$render = ->
    scope.feed = scope._original = ngModel.$modelValue
    for link in scope.feed.links
      link.url = "/" + i++
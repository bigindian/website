module.exports = (scope, element, attrs, ngModel) ->
  read = -> ngModel.$setViewValue element.html()
  ngModel.$render = -> element.html ngModel.$viewValue or ""

  element.bind "blur keyup change", -> scope.$apply read
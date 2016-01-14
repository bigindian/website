Directive = module.exports = ($timeout, angular) ->
  restrict: 'A'
  link: require("./link") $timeout, angular


Directive.$inject = [
  "$timeout"
  "angular"
]
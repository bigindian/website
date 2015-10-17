Directive = module.exports = (RecursionHelper) ->
  controller: require "./controller"
  require: "ngModel"
  # link: require "./link"
  scope: true
  templateUrl: "components/news-comment/template"
  compile: (element) ->
    #! Use the compile function from the RecursionHelper, and return the
    #! linking function(s) which it returns
    RecursionHelper.compile element, require "./link"


Directive.$inject = ["@recursionHelper"]
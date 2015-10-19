Directive = module.exports = (RecursionHelper) ->
  compile: (element) ->
    # Use the compile function from the RecursionHelper, and return the
    # linking function(s) which it returns
    RecursionHelper.compile element, require "./link"

  controller: require "./controller"
  require: "ngModel"
  scope:
    allowReporting: "="
    allowSubCommenting: "="
    isNotInStory: "="
  templateUrl: "components/news-comment/template"


Directive.$inject = ["@recursionHelper"]
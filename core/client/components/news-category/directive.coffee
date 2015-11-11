Directive = module.exports = ->
  controller: require "./controller"
  link: require "./link"
  require: "ngModel"
  scope:
    disableHref: "="
  templateUrl: "components/news-category/template"
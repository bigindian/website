Directive = module.exports = ->
  controller: require "./controller"
  link: require "./link"
  scope: feeds: "="
  require: "ngModel"
  templateUrl: "components/news-list/template"
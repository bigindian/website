Directive = module.exports = ->
  controller: require "./controller"
  link: require "./link"
  scope: true
  require: "ngModel"
  templateUrl: "components/news-card/template"
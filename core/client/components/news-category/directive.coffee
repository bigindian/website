Directive = module.exports = ->
  link: require "./link"
  require: "ngModel"
  scope: true
  templateUrl: "components/news-category/template"
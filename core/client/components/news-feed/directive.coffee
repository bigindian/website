module.exports = Directive = ->
  controller: require "./controller"
  link: require "./link"
  require: "ngModel"
  scope: true
  templateUrl: "components/news-feed/template"
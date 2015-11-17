Directive = module.exports = ->
  controller: require "./controller"
  link: require "./link"
  require: "ngModel"
  scope: feed: "="
  templateUrl: "components/news-feed/news-feed-item/template"
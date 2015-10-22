module.exports = Directive = ->
  controller: require "./controller"
  require: "ngModel"
  link: require "./link"
  scope:
    allowEditing: "="
    allowReporting: "="
    showCommentBox: "="
    showDescription: "="
  templateUrl: "components/news-item/template"
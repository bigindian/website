module.exports = Directive = ->
  controller: require "./controller"
  require: "ngModel"
  link: require "./link"
  scope:
    showCommentBox: "="
    showDescription: "="
    allowEditing: "="
  templateUrl: "components/news-item/template"
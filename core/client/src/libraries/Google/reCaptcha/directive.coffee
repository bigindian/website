exports = module.exports = ->
  controller: require "./controller"
  link: require "./link"
  require: "ngModel"
  scope: true
  templateUrl: "libraries/Google/reCaptcha/template"
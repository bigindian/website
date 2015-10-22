module.exports = (app) ->
  app.directive "googleRecaptcha",  require "./reCaptcha/directive"
  app.service "$google/analytics",  require "./analytics"
  app.service "@google/recaptcha",  require "./reCaptcha/service"
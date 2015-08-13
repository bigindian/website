module.exports = (app) ->
  console.log "[common:providers] initializing"
  app.provider "$environment", require "./environment"
  app.provider "$i18n", require "./i18n"

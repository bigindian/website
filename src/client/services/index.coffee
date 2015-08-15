module.exports = (app) ->
  console.log "initializing services"
  app.service "@base64",            require "./base64"
  app.service "@notifications",     require "./notifications"
  app.service "@storage",           require "./storage"
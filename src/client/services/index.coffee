module.exports = (app) ->
  console.log "initializing services"
  app.service "@base64",            require "./base64"
  app.service "@storage",           require "./storage"
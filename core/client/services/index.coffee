module.exports = (app) ->
  console.log "initializing services"

  app.service "@cache",             require "./localCache"
  app.service "@base64",            require "./base64"
  app.service "@settings",          require "./settings"
  app.service "@storage",           require "./storage"
  app.service "@recursionHelper",   require "./recursionHelper"
  app.service "@api",               require "./api"
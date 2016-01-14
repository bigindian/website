module.exports = (app) ->
  console.log "initializing services"

  app.service "@api",               require "./api"
  app.service "@base64",            require "./base64"
  app.service "@cache",             require "./localCache"
  app.service "@notifications",     require "./notifications"
  app.service "@recursionHelper",   require "./recursionHelper"
  app.service "@settings",          require "./settings"
  app.service "@storage",           require "./storage"

  app.factory "@modalGenerator",    require "./modalGenerator"
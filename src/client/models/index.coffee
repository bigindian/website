module.exports = (app) ->
  console.log "initializing models"

  app.factory "@models/base/enum",           require "./base/enum"
  app.factory "@models/news/categories",     require "./categories"
  app.factory "@models/news/stories",        require "./stories"
  app.factory "@models/categories",          require "./categories"
  app.factory "@models/languages",           require "./languages"
  app.factory "@models/users",               require "./users"
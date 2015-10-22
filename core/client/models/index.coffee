module.exports = (app) ->
  console.log "initializing models"

  app.factory "@models/base/enum",           require "./base/enum"
  # app.factory "@models/base/api",            require "./base/api"
  # app.factory "@models/base/model",          require "./base/model"
  # app.factory "@models/base/collection",     require "./base/collection"

  app.factory "@models/languages",           require "./languages"
  app.factory "@models/news",                require "./news"
  app.factory "@models/news/comments",       require "./news/comments"
  app.factory "@models/news/categories",     require "./news/categories"
  app.factory "@models/news/stories",        require "./news/stories"
  app.factory "@models/users",               require "./users"
  app.factory "@models/session",             require "./session"
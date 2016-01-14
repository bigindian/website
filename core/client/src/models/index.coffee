module.exports = (app) ->
  console.log "initializing models"

  app.factory "@models/base/enum",           require "./base/enum"
  # app.factory "@models/base/api",            require "./base/api"
  # app.factory "@models/base/model",          require "./base/model"
  # app.factory "@models/base/collection",     require "./base/collection"

  app.factory "@models/languages",           require "./languages"
  app.factory "@models/news",                require "./news"
  app.factory "@models/news/comments",       require "./news/comments"
  app.factory "@models/news/tags",           require "./news/tags"
  app.factory "@models/news/stories",        require "./news/stories"
  # app.factory "@models/news/articles",       require "./news/articles"
  # app.factory "@models/news/feeds",          require "./news/feeds"
  app.factory "@models/users",               require "./users"
  app.factory "@models/session",             require "./session"
module.exports = (app) ->
  console.log "[common:views] initializing"
  app.controller "error/404", require "./error/404/controller"

  app.controller "auth/forgot",      require "./auth/login/controller"
  app.controller "auth/login",       require "./auth/login/controller"
  app.controller "auth/logout",      require "./auth/logout/controller"
  app.controller "auth/signup",      require "./auth/signup/controller"

  app.controller "news/categories",  require "./news/categories/controller"
  app.controller "news/filters",     require "./news/filters/controller"
  app.controller "news/index",       require "./news/index/controller"
  app.controller "news/search",      require "./news/search/controller"
  app.controller "news/single",      require "./news/single/controller"
  app.controller "news/recent",      require "./news/recent/controller"
  app.controller "news/submit",      require "./news/submit/controller"

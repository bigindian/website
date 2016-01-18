module.exports = (app) ->
  console.log "initializing views"


  app.controller "error/404",          require "./error/404/controller"

  app.controller "info/about",         require "./info/about/controller"
  app.controller "info/contribute",    require "./info/contribute/controller"
  app.controller "info/terms-privacy", require "./info/terms-privacy/controller"

  # app.controller "auth/forgot",      require "./auth/login/controller"
  app.controller "auth/login",         require "./auth/login/controller"
  app.controller "auth/logout",        require "./auth/logout/controller"
  app.controller "auth/signup",        require "./auth/signup/controller"

  app.controller "news/categories",    require "./news/categories/controller"
  app.controller "news/feed",          require "./news/feed/controller"
  app.controller "news/index",         require "./news/index/controller"
  app.controller "news/new",           require "./news/new/controller"
  app.controller "news/newsletter",    require "./news/newsletter/controller"
  app.controller "news/recent",        require "./news/recent/controller"
  app.controller "news/search",        require "./news/search/controller"
  app.controller "news/comments",      require "./news/comments/controller"
  app.controller "news/single",        require "./news/single/controller"

  app.controller "users/single",        require "./users/single/controller"
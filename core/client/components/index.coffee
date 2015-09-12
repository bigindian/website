module.exports = (app) ->
  console.log "initializing components"

  app.directive "footer",          require "./footer/directive"
  app.directive "header",          require "./header/directive"
  app.directive "headerHamburger", require "./header/hamburger/directive"
  app.directive "newsCategory",    require "./news-category/directive"
  app.directive "newsComment",     require "./news-comment/directive"
  app.directive "newsItem",        require "./news-item/directive"
  app.directive "notifications",   require "./notifications/directive"
  app.directive "formCheckbox",   require "./form/checkbox/directive"

  app.service   "@notifications",  require "./notifications/service"
module.exports = (app) ->
  console.log "initializing components"


  app.directive "clamp",           require "./clamp/directive"
  app.directive "contenteditable", require "./contenteditable/directive"
  # app.directive "footer",          require "./footer/directive"
  app.directive "formCheckbox",    require "./form/checkbox/directive"
  app.directive "header",          require "./header/directive"
  app.directive "newsCategory",    require "./news-category/directive"
  # app.directive "newsComment",     require "./news-comment/directive"
  # app.directive "newsItem",        require "./news-item/directive"
  app.directive "notifications",   require "./notifications/directive"
  app.directive "sitePreviewer",   require "./site-previewer/directive"

  app.directive "newsFeed",        require "./news-feed/directive"
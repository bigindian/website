module.exports = (app) ->
  console.log "initializing components"


  # app.directive "newsComment",     require "./news-comment/directive"
  # app.directive "newsItem",        require "./news-item/directive"
  app.directive "modal",           require "./modal/directive"
  app.directive "clamp",           require "./clamp/directive"
  app.directive "footer",          require "./footer/directive"
  app.directive "header",          require "./header/directive"
  app.directive "newsCategory",    require "./news-category/directive"
  app.directive "newsFeed",        require "./news-feed/directive"
  app.directive "newsList",        require "./news-list/directive"
  app.directive "newsFeedItem",    require "./news-feed/news-feed-item/directive"
  app.directive "notifications",   require "./notifications/directive"
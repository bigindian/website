module.exports = (app) ->
  console.log "[news:components] initializing"
  app.directive "newsCategory", require "./news-category/directive"
  app.directive "newsItem", require "./news-item/directive"
  app.directive "newsComment", require "./news-comment/directive"
  app.directive "header", require "./header/directive"
  # app.directive "footer", require "./footer/directive"
  app.directive "headerHamburger", require "./header/hamburger/directive"
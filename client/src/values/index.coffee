module.exports = (app) ->
  console.log "initializing values"
  app.value "$anchorScroll", window.angular.noop
  app.value "$log", console


  app.value "Masonry", window.Masonry
  app.value "_", window._
  app.value "angular", window.angular
  app.value "underscore", window._
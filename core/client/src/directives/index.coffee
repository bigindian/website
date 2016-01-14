module.exports = (app) ->
  console.log "initializing directives"
  app.directive "fnImageLoader",      require "./fnImageLoader"
  app.directive "fnLikeViewport",     require "./fnLikeViewport"
  app.directive "fnModelFile",        require "./fnModelFile"
  app.directive "fnRoute",            require "./fnRoute"
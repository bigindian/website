module.exports = (app) ->
  console.log "initializing libraries"
  require("./Google")   app
  require("./Backbone") app
  require("./Packery")  app
module.exports = (app) ->
  console.log "initializing libraries"
  require("./Backbone") app
  require("./Google")   app
  require("./Packery") app
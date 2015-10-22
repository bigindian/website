module.exports = (app) ->
  console.log "initializing libraries"
  require("./Google") app
  require("./Backbone") app
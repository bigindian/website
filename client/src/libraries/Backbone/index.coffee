module.exports = (app) ->
  console.log "initializing libraries"
  app.factory "Backbone", require "./Backbone"
  app.factory "BackboneCollection", require "./Collection"
  app.factory "BackboneModel", require "./Model"
  app.factory "BackboneCache", require "./Cache"
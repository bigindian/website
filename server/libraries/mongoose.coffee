mongoose = require "mongoose"


Library = module.exports = (IoC, settings) ->
  config = settings.mongo
  url = "mongodb://#{config.username}:#{config.password}@#{config.host}:#{config.port}/#{config.database}"
  mongoose.connect url
  mongoose


Library["@singleton"] = true
Library["@require"] = [
  "$container"
  "igloo/settings"
]
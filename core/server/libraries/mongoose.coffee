mongoose = require "mongoose"


Library = module.exports = (IoC, settings) ->
  mongoose.connect "mongodb://localhost/thebigindian"
  mongoose


Library["@singleton"] = true
Library["@require"] = [
  "$container"
  "igloo/settings"
]
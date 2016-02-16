findOrCreate     = require "mongoose-findorcreate"
Schema           = (require "mongoose").Schema


Model = module.exports = (Mongoose) ->
  schema = new Schema
    uid: type: String, index: true
    created_at: type: Date, default: Date.now, index: true

  schema.plugin findOrCreate

  Mongoose.model "Android", schema


Model["@singleton"] = true
Model["@require"] = ["libraries/mongoose"]
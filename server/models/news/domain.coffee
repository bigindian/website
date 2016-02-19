findOrCreate     = require "mongoose-findorcreate"
Schema           = (require "mongoose").Schema


Model = module.exports = (Mongoose) ->
  schema = new Schema
    domain: type: String, index: unique: true
    last_title: String
    story_count: Number
    title_remove_regex: String


  schema.plugin findOrCreate
  Mongoose.model "Domain", schema


Model["@singleton"] = true
Model["@require"] = ["libraries/mongoose"]
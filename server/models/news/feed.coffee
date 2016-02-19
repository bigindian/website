Schema           = (require "mongoose").Schema


Model = module.exports = (Elasticsearch, Mongoose, User) ->
  schema = new Schema
    url: type: String, index: unique: true
    story_count: Number


  Mongoose.model "Feed", schema


Model["@singleton"] = true
Model["@require"] = [
  "libraries/elasticsearch"
  "libraries/mongoose"
  "models/user"
]
Schema = (require "mongoose").Schema


Model = module.exports = (Elasticsearch, Mongoose, User) ->
  schema = new Schema
    domain: type: String, index: unique: true
    title_replace_regex: String, default: ""


  Mongoose.model "Domain", schema


Model["@singleton"] = true
Model["@require"] = [
  "libraries/elasticsearch"
  "libraries/mongoose"
  "models/user"
]
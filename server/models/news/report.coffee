Promise          = require "bluebird"
Schema           = (require "mongoose").Schema
url              = require "url"
validator        = require "validator"
# mongoosastic     = require "mongoosastic"
mongoosePaginate = require "mongoose-paginate"


Model = module.exports = (Elasticsearch, Mongoose, User) ->
  schema = new Schema
    reason: String
    type: String
    story: type: Schema.Types.ObjectId, ref: "Story"

    created_by: type: Schema.Types.ObjectId, ref: "User"
    created_at: type: Date, default: Date.now, index: true
  schema.plugin mongoosePaginate


  Mongoose.model "Report", schema


Model["@singleton"] = true
Model["@require"] = [
  "libraries/elasticsearch"
  "libraries/mongoose"
  "models/user"
]
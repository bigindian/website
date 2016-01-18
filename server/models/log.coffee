# Promise   = require "bluebird"
# bCrypt    = require "bcrypt-nodejs"
# validator = require "validator"


# Model = module.exports = (Bookshelf) ->
#   Bookshelf.model "logs", Bookshelf.Model.extend
#     tableName: "logs"
#     cache: true
#     require: true

#     enums: types: tableName: "log_types", pick: "name"


# Model["@require"] = ["models/base/bookshelf"]
# Model["@singleton"] = true
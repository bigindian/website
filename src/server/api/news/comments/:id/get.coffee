Promise = require "bluebird"
validator = require "validator"


exports = module.exports = (Comments) ->
  controller = (request, response, next) ->
    Comments.get request.params[0]
    .then (comment) -> response.json comment
    .catch ->
      response.status 404
      response.json {}


exports["@require"] = ["models/news/comments"]
exports["@singleton"] = true
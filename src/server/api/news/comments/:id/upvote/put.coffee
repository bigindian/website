Promise = require "bluebird"
validator = require "validator"


exports = module.exports = (Comments) ->
  controller = (request, response, next) ->
    Comments.get request.params[0]
    .then (comment) -> comment.upvote request.user.id
    .then -> response.json "voted"
    .catch (e) -> next e


exports["@require"] = ["models/news/comments"]
exports["@singleton"] = true
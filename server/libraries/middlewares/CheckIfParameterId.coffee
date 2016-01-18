validator = require "validator"


Middleware = module.exports = (NotFoundError) ->
  (request, response, next, value) ->
    if validator.isMongoId value then next()
    else next new NotFoundError()


Middleware["@singleton"] = true
Middleware["@require"] = ["libraries/errors/NotFoundError"]
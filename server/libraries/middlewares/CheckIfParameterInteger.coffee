validator = require "validator"


Middleware = module.exports = (NotFoundError) ->
  (request, response, next, value) ->
    if validator.isInt value then next()
    else next new NotFoundError()


Middleware["@singleton"] = true
Middleware["@require"] = ["libraries/errors/NotFoundError"]
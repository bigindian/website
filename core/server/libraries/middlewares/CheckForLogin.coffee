Middleware = module.exports = (NeedAuthenticationError) ->
  (request, response, next) ->
    if request.isAuthenticated() then next()
    else next new NeedAuthenticationError()


Middleware["@singleton"] = true
Middleware["@require"] = ["libraries/errors/NeedAuthenticationError"]
Controller = module.exports = ->
  (request, response, next) ->
    request.session.destroy()
    response.json {}


Controller["@routes"] = ["/auth/logout"]
Controller["@singleton"] = true
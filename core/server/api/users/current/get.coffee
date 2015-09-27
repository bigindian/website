Controller = module.exports = ->
  (request, response, next) ->
    user = request.user
    json = {}

    if user?
      json = user.toJSON()
      json.meta ?= {}

      # Get rid of sensitive fields
      delete json.meta.activationToken
      delete json.password

    response.json json


Controller["@routes"] = ["/users/current"]
Controller["@singleton"] = true
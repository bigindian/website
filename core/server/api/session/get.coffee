Controller = module.exports = ->
  (request, response, next) ->
    user = request.user
    if user? then response.json user
    else response.json {}


Controller["@routes"] = ["/session"]
Controller["@singleton"] = true
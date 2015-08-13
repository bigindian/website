exports = module.exports = (Renderer) ->
  controller = (request, response, next) ->
    options = page: "auth/login"
    Renderer request, response, options, false


exports["@require"] = ["libraries/renderer"]
exports["@singleton"] = true

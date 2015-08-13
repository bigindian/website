exports = module.exports = (Renderer) ->
  controller = (request, response, next) ->
    options = page: "auth/signup"
    Renderer request, response, options, false


exports["@require"] = ["libraries/renderer"]
exports["@singleton"] = true

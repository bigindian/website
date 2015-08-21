exports = module.exports = (Renderer) ->
  controller = (request, response, next) ->
    args = page: "info/donate"
    Renderer request, response, args, true


exports["@require"] = ["libraries/renderer"]
exports["@singleton"] = true
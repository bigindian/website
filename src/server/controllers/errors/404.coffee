exports = module.exports = (Renderer) ->
  controller = (request, response, next) ->
    response.status 404

    options =
      page: "errors/404"
      title: "Page not found"
    Renderer request, response, options


exports["@require"] = ["libraries/renderer"]
exports["@singleton"] = true

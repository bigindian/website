exports = module.exports = (Renderer) ->
  routes: ["/signup"]
  controller: (request, response, next) ->
    response.render "main/auth/signup", cache: true


exports["@require"] = ["libraries/renderer"]
exports["@singleton"] = true
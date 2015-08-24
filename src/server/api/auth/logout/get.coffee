exports = module.exports = ->
  routes: ["/auth/email/login"]

  controller: (request, response, next) ->
    request.session.destroy()
    response.json {}


exports["@singleton"] = true
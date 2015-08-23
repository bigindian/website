exports = module.exports = ->
  routes: ["/login"]

  controller: (request, response, next) ->
    response.render "main/auth/login", cache: "main/auth/login"


exports["@singleton"] = true
exports = module.exports = ->
  routes: ["/login"]

  controller: (request, response, next) ->
    response.render "main/auth/login", cache: enable: true


exports["@singleton"] = true
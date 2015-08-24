exports = module.exports = ->
  routes: ["/signup"]
  controller: (request, response, next) ->
    response.render "main/auth/signup", cache: enable: true


exports["@singleton"] = true
Controller = module.exports = ->
  (request, response, next) ->
    response.render "main/auth/signup",
      cache: enable: true
      metaRobots: "noindex"


Controller["@singleton"] = true
Controller["@routes"] = ["/signup"]
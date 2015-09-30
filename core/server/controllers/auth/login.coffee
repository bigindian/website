Controller = module.exports = ->
  (request, response, next) ->
    response.render "main/auth/login",
      cache: enable: true
      metaRobots: "noindex"


Controller["@routes"] = ["/login"]
Controller["@singleton"] = true
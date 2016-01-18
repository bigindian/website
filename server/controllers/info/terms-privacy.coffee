Controller = module.exports = ->
  (request, response, next) ->
    response.render "main/info/terms-privacy",
      cache: enable: true
      metaRobots: "nofollow"


Controller["@routes"] = ["/info/terms-privacy"]
Controller["@singleton"] = true
Controller = module.exports = ->
  (request, response, next) ->
    response.render "main/info/donate",
      cache: enable: true
      metaRobots: "nofollow"


Controller["@routes"] = ["/info/contribute"]
Controller["@singleton"] = true
Controller = module.exports = ->
  (request, response, next) ->
    response.render "main/news/settings",
      metaRobots: "noindex"
      cache: enable: true


Controller["@routes"] = ["/newsletter"]
Controller["@singleton"] = true
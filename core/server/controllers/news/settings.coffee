Controller = module.exports = ->
  (request, response, next) ->
    response.render "main/news/settings",
      metaRobots: "noindex"
      cache: enable: true


Controller["@routes"] = ["/settings"]
Controller["@singleton"] = true
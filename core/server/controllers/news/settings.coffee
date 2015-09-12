exports = module.exports = ->
  routes: ["/settings"]

  controller: (request, response, next) ->
    response.render "main/news/settings",
      metaRobots: "noindex"
      cache: enable: true


exports["@singleton"] = true
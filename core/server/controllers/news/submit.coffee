exports = module.exports = ->
  routes: ["/submit"]

  controller: (request, response, next) ->
    response.render "main/news/submit",
      cache: enable: true
      metaRobots: "noindex"


exports["@singleton"] = true
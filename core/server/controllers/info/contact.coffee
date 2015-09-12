exports = module.exports = ->
  controller: (request, response, next) ->
    response.render "main/info/contact",
      cache: enable: true
      metaRobots: "nofollow"


exports["@singleton"] = true
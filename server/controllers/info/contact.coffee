Controller = module.exports = ->
  (request, response, next) ->
    response.render "main/info/contact",
      cache: enable: true
      metaRobots: "nofollow"


Controller["@singleton"] = true
Controller = module.exports = ->
  (request, response, next) ->
    response.render "main/news/submit",
      cache: enable: true
      metaRobots: "noindex"


# Controller["@middlewares"] = ["EnsureLoggedIn"]
Controller["@routes"] = ["/stories/new"]
Controller["@singleton"] = true
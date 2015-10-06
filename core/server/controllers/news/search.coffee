Controller = module.exports = (ElasticSearch) ->
  (request, response, next) ->
    response.render "main/auth/login",
      metaRobots: "noindex"


Controller["@require"] = ["libraries/elasticsearch"]
Controller["@routes"] = ["/search"]
Controller["@singleton"] = true
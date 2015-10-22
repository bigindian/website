Controller = module.exports = (ElasticSearch) ->
  (request, response, next) ->
    response.render "main/news/search",
      metaRobots: "noindex"


Controller["@require"] = ["libraries/elasticsearch"]
Controller["@routes"] = ["/search"]
Controller["@singleton"] = true
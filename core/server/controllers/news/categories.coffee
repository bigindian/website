Promise = require "bluebird"


Controller = module.exports = (Categories) ->
  (request, response, next) ->
    Promise.props
      counters: Categories.getStoryCount()
      categories: Categories.getAll()
    .then (results) ->
      response.render "main/news/categories",
        data:
          counters: results.counters
          categories: results.categories.toJSON()
        metaRobots: "noarchive"
        cache: enable: true


Controller["@require"] = ["models/news/categories"]
Controller["@routes"] = ["/categories"]
Controller["@singleton"] = true
Promise = require "bluebird"


exports = module.exports = (Categories) ->
  routes: ["/categories"]

  controller: (request, response, next) ->
    Promise.props
      counters: Categories.getStoryCount()
      categories: Categories.getAll()
    .then (results) ->
      response.render "main/news/categories",
        data: results
        metaRobots: "noarchive"
        cache: enable: true


exports["@require"] = ["models/news/categories"]
exports["@singleton"] = true
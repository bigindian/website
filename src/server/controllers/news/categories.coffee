Promise = require "bluebird"


exports = module.exports = (Renderer, Categories) ->
  controller = (request, response, next) ->
    Promise.props
      counters: Categories.getStoryCount()
      categories: Categories.getAll()
    .then (results) ->
      options =
        page: "news/categories"
        data: results
      Renderer request, response, options


exports["@require"] = [
  "libraries/renderer"
  "models/news/categories"
]
exports["@singleton"] = true
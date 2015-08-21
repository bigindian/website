exports = module.exports = (Renderer, Categories) ->
  controller = (request, response, next) ->
    options = page: "news/settings"
    Renderer request, response, options


exports["@require"] = [
  "libraries/renderer"
  "models/news/categories"
]
exports["@singleton"] = true
exports = module.exports = ->
  routes: ["/settings"]

  controller: (request, response, next) ->
    response.render "main/news/settings", cache: true


exports["@singleton"] = true
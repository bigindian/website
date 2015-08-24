exports = module.exports = ->
  routes: ["/settings"]

  controller: (request, response, next) ->
    response.render "main/news/settings", cache: enable: true


exports["@singleton"] = true
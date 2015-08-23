exports = module.exports = ->
  routes: ["/submit"]

  controller: (request, response, next) ->
    response.render "main/news/submit", cache: true


exports["@singleton"] = true
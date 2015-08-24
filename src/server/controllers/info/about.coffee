exports = module.exports = ->
  controller: (request, response, next) ->
    response.render "main/info/about", cache: enable: true


exports["@singleton"] = true
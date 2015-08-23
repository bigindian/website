exports = module.exports = ->
  controller: (request, response, next) ->
    response.render "main/info/about", cache: true


exports["@singleton"] = true
exports = module.exports = ->
  controller: (request, response, next) ->
    response.render "main/info/terms-privacy", cache: true


exports["@singleton"] = true
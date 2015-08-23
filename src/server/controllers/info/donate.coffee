exports = module.exports = ->
  controller: (request, response, next) ->
    response.render "main/info/donate", cache: true


exports["@singleton"] = true
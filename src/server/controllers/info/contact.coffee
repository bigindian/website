exports = module.exports = ->
  controller: (request, response, next) ->
    response.render "main/info/contact", cache: true


exports["@singleton"] = true
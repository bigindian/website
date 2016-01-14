Request = require "request"
http = require "http"


Controller = module.exports = (Story) ->
  (request, response, next) ->

    url = request.query.url or ""
    Request.get url, ->
      str = body.toString()

      regex = /(<\s*title[^>]*>(.+?)<\s*\/\s*title)>/gi
      match = regex.exec str

      if (match && match[2]) then response.json title: match[2]
      else
        response.status 400
        response.json title: ""


Controller["@require"] = ["models/news/story"]
Controller["@routes"] = ["/news/helpers/fetch_title"]
Controller["@singleton"] = true
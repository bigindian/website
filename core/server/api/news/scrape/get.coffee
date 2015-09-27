cheerio = require "cheerio"
Request = require "request"


Controller = module.exports = (Stories) ->
  (request, response, next) ->
    url = request.query.u or ""

    Request
      url: url
      maxRedirects: 20
    , (error, res, html) ->
      if not error and res.statusCode is 200
        try
          results = html.match /<title>(.*?)<\/title>/
          title =  results[1]
        catch e then title = ""

        if title is "" then title = ":("

        #! Return!
        response.json url: url, title: title

      #! Something wicked happened! Return..
      else response.json url: url, title: ":("


Controller["@middlewares"] = ["CheckForLogin"]
Controller["@require"] = ["models/news/stories"]
Controller["@routes"] = ["/news/scrape"]
Controller["@singleton"] = true
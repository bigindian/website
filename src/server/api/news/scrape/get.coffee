cheerio = require "cheerio"
Request = require "request"


exports = module.exports = (Stories) ->
  routes: ["/news/scrape"]

  controller: (request, response, next) ->
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


exports["@require"] = ["models/news/stories"]
exports["@singleton"] = true
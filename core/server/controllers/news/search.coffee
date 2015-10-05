Promise = require "bluebird"


Controller = module.exports = (ElasticSearch) ->
  isNotEmpty = (value) -> value? and value != ""

  (request, response, next) ->
    compulsaryQueries = []
    optionalQueries = []

    (do (query = request.query) ->
      # If a query or a domain was not set, then don't query at all!
      if not isNotEmpty(query.q) and not isNotEmpty(query.domain)
        return Promise.resolve error: "emptyQuery"


      # If the query string was set, then..
      if isNotEmpty query.q
        optionalQueries.push
          fuzzy:
            title:
              value: request.query.q,
              boost: 3

        optionalQueries.push
          fuzzy:
            content:
              value: request.query.q,
              boost: 2

        # optionalQueries.push fuzzy: content: request.query.q

      if isNotEmpty request.query.domain
        compulsaryQueries.push match: domain: request.query.domain

      esQuery =
        index: "bigindiannews"
        body: query: bool:
          must: compulsaryQueries
          should: optionalQueries

      # If the user is looking for stories or comments specifically
      switch request.query.what
        when "stories" then esQuery.type = "stories"
        when "comments" then esQuery.type = "comments"


      ElasticSearch.client.search esQuery
    ).then (results) ->

        response.render "main/auth/login",
          data: results
          metaRobots: "noindex"


Controller["@require"] = ["libraries/elasticsearch"]
Controller["@routes"] = [
  "/search"
]
Controller["@singleton"] = true
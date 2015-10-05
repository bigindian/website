Promise = require "bluebird"


Controller = module.exports = (ElasticSearch) ->
  isNotEmpty = (value) -> value? and value != ""

  (request, response, next) ->
    compulsaryQueries = []
    optionalQueries = []
    query = request.query

    # If a query or a domain was not set, then don't query at all!
    if not isNotEmpty(query.q) and not isNotEmpty(query.domain)
      return response.json {}

    # If the query string was set, then..
    if isNotEmpty query.q
      optionalQueries.push
        fuzzy: title:
          value: query.q,
          boost: 3

      optionalQueries.push
        fuzzy:
          content:
            value: query.q,
            boost: 2

      # optionalQueries.push fuzzy: content: request.query.q

    if isNotEmpty query.domain
      compulsaryQueries.push match: domain: query.domain

    esQuery =
      body: query: bool:
        must: compulsaryQueries
        should: optionalQueries

    # If the user is looking for stories or comments specifically
    switch request.query.what
      when "stories" then esQuery.type = "stories"
      when "comments" then esQuery.type = "comments"


    ElasticSearch.search esQuery
    .then (results) -> response.json results
    .catch (e) -> next e


Controller["@require"] = ["libraries/elasticsearch"]
Controller["@routes"] = ["/news"]
Controller["@singleton"] = true
Controller = module.exports = (Story) ->
  (request, response, next) ->
    options =
      offset: 0
      limit: 10
      sort: hotness: -1

    Story.paginate {}, options
    .then (result) -> response.json result


Controller["@require"] = ["models/news/story"]
Controller["@routes"] = ["/news/stories"]
Controller["@singleton"] = true
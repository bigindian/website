Controller = module.exports = (Story) ->
  (request, response, next) ->
    options =
      offset: 0
      limit: 10

    options.sort = if request.query.recent then created_at: -1 else hotness: -1

    Story.paginate {}, options
    .then (result) -> response.json result


Controller["@require"] = ["models/news/story"]
Controller["@routes"] = ["/news/stories"]
Controller["@singleton"] = true
Controller = module.exports = (Reports) ->
  (request, response, next) ->
    stories_per_page = 10
    options =
      offset: stories_per_page * (request.query.page - 1)
      limit: stories_per_page

    # options.sort = if request.query.recent then created_at: -1 else hotness: -1

    Reports.paginate {}, options
    .then (result) -> response.json result


Controller["@require"] = ["models/news/report"]
Controller["@routes"] = ["/news/reports"]
Controller["@singleton"] = true
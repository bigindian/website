Controller = module.exports = (Story) ->
  (request, response, next) ->
    stories_per_page = 40
    options =
      offset: stories_per_page * (request.query.page - 1)
      limit: stories_per_page

    options.sort = if request.query.recent then created_at: -1 else hotness: -1

    Story.paginate is_banned: null, options
    .then (result) -> response.json result


Controller["@require"] = ["models/news/story"]
Controller["@routes"] = ["/news/stories"]
Controller["@singleton"] = true
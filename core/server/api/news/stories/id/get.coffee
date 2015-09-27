###
  @api {get} /api/news/stories/:story Get a single story
  @apiName Get a single story
  @apiGroup Stories
  @apiVersion 1.0.0

  @apiDescription Destroys the current session of the logged in user.

  @apiParam {Number} page the page number to fetch from

  @apiExample {curl} Example
    curl -i https://thebigindian.news/api/news/stories/1

  @apiUse StoryModelResponse
###
Controller = module.exports = (Stories) ->
  (request, response, next) ->
    Stories.get request.params.id
    .then (story) -> response.json story
    .catch ->
      response.status 404
      response.json {}


Controller["@require"] = ["models/news/stories"]
Controller["@routes"] = ["/news/stories/:id"]
Controller["@singleton"] = true
###
  @api {post} /api/news/stories Create a story
  @apiName Create a story
  @apiGroup Stories
  @apiVersion 1.0.0

  @apiDescription Creates a new story

  @apiParam {Number} page the page number to fetch from

  @apiUse StoryModelResponse
###
Controller = module.exports = (Stories) ->
  (request, response, next) ->
    request.body.created_by = request.user.id

    Stories.create request.body
    .then (story) -> response.json story
    .catch (e) -> next e


Controller["@middlewares"] = ["CheckForLogin", "CheckCaptcha"]
Controller["@require"] = ["models/news/stories"]
Controller["@routes"] = ["/news/stories"]
Controller["@singleton"] = true
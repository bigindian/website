###
  @api {put} /api/news/stories/:story Update a story
  @apiName Update a story
  @apiGroup Stories
  @apiVersion 1.0.0

  @apiDescription Destroys the current session of the logged in user.

  @apiParam {Number} page the page number to fetch from

  @apiExample {curl} Example
    curl -i https://thebigindian.news/api/news/stories/1 -XPUT --data ''

  @apiUse StoryModelResponse
###
Controller = module.exports = (Stories) ->
  (request, response, next) ->
    data = request.body or {}

    Stories.get request.params.id
    .then (story) ->
      story.set "description_markdown", data.description_markdown
      story.set "title", data.title
      story.save()
      .then -> response.json story
    .catch (e) -> next e


Controller["@require"] = ["models/news/stories"]
Controller["@routes"] = ["/news/stories/:id"]
Controller["@singleton"] = true
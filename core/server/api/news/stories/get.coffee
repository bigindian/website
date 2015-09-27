###
  @api {get} /api/news/stories?page={page_number} Get all stories
  @apiName Get all Stories
  @apiGroup Stories
  @apiVersion 1.0.0

  @apiDescription Destroys the current session of the logged in user.

  @apiParam {Number} page the page number to fetch from

  @apiExample {curl} Example
    curl -i https://thebigindian.news/api/news/stories
  @apiExample {curl} Page 4
    curl -i https://thebigindian.news/api/news/stories?page=4

  @apiSuccess {Array} collection An array of stories
  @apiSuccess {Object} pagination contains information useful for pagination
  @apiSuccessExample {json} Success-Response:
    {
      "collection": [
        {
          "id": 1,
          "title": "This is the first link",
          "domain": "github.com",
          ...
        }, ...
      ],
      "pagination": {
        "limit": 20,
        "next": 3,
        "page": 2,
        "pages": 100,
        "prev": 1,
        "total": "2000"
      }
    }
###
Controller = module.exports = (Stories) ->
  (request, response, next) ->
    Stories.query().then (stories) ->  response.json stories
    .catch ->
      response.status 404
      response.json "no stories"


Controller["@require"] = ["models/news/stories"]
Controller["@routes"] = ["/news/stories"]
Controller["@singleton"] = true
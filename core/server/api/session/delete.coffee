###
  @api {delete} /api/session Logout
  @apiName Logout
  @apiGroup Authentication
  @apiVersion 1.0.0

  @apiDescription Destroys the current session of the logged in user.

  @apiSuccessExample {json} Success-Response:
  HTTP/1.1 200 OK
  {
    "status": "ok"
  }
###
Controller = module.exports = ->
  (request, response, next) ->
    request.session.destroy()
    response.json status: "ok"


Controller["@routes"] = ["/session"]
Controller["@singleton"] = true
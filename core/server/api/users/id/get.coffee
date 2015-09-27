###
@api {get} /users/:id Get a single user
@apiName GetUser
@apiGroup User

@apiParam {Number} id Users unique ID.

@apiSuccess {String} firstname Firstname of the User.
@apiSuccess {String} lastname  Lastname of the User.
@apiVersion 1.0.0
###
Controller = module.exports = (Users) ->
  (request, response, next) ->
    Users.get request.params.id
    .then (user) -> response.json user


Controller["@require"] = ["models/users"]
Controller["@routes"] = ["/users/:id"]
Controller["@singleton"] = true
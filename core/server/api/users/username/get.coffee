Controller = module.exports = (Users) ->
  (request, response, next) ->
    Users.findByUsernameOrEmail request.params.username
    .then (user) -> response.json user
    .catch (e) -> next e


Controller["@require"] = ["models/users"]
Controller["@routes"] = ["/users/username/:username"]
Controller["@singleton"] = true
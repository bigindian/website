Controller = module.exports = (Users) ->
  (request, response, next) ->
    Users.query().then (users) ->
      for user in users
        delete user.password
        delete user.credits
      response.json users


Controller["@require"] = ["models/users"]
Controller["@singleton"] = true
Controller["@routes"] = ["/users/([0-9]+)"]
exports = module.exports = (Users) ->
  routes: ["/users/([0-9]+)"]
  controller: (request, response, next) ->
    Users.query().then (users) ->
      for user in users
        delete user.password
        delete user.credits
      response.json users


exports["@require"] = ["models/users"]
exports["@singleton"] = true
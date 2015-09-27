Promise = require "bluebird"
validator = require "validator"


Controller = module.exports = (Users) ->
  (request, response, next) ->
    Users.findByUsernameOrEmail request.params.username
    .then (user) ->
      if not user? then throw new Error

      user = user.toJSON()
      delete user.credits
      delete user.mailing_list_token
      delete user.password
      delete user.rss_token

      response.json user
    .catch ->
      response.status 404
      response.json {}

Controller["@require"] = ["models/users"]
Controller["@routes"] = ["/users/username/:username"]
Controller["@singleton"] = true
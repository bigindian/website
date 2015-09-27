expect           = require "expect.js"
supertest        = require "supertest"

Controller = module.exports = (IoC) -> (app) ->

Controller["@require"] = ["$container"]
Controller["@singleton"] = true

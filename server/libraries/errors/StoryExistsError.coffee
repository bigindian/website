exports = module.exports = (IoC) ->
  StoryExistsError = ->
    Error.captureStackTrace this, @constructor
    this.name = @constructor.name
    this.message = "StoryExistsError"
    this.status = 400

  require("util").inherits StoryExistsError, Error
  StoryExistsError


exports["@singleton"] = true
exports["@require"] = ["$container"]

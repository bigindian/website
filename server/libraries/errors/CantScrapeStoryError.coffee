exports = module.exports = (IoC) ->
  CantScrapeStoryError = ->
    Error.captureStackTrace this, @constructor
    this.name = @constructor.name
    this.message = "CantScrapeStoryError"
    this.status = 400

  require("util").inherits CantScrapeStoryError, Error
  CantScrapeStoryError


exports["@singleton"] = true
exports["@require"] = ["$container"]
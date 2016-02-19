exports = module.exports = (IoC) ->
  CantScrapeStoryError = (details) ->
    Error.captureStackTrace this, @constructor
    @name = @constructor.name
    @message = "CantScrapeStoryError"
    @details = details
    @status = 400

  require("util").inherits CantScrapeStoryError, Error
  CantScrapeStoryError


exports["@singleton"] = true
exports["@require"] = ["$container"]
exports = module.exports = (NotFoundError) ->
  controller: (request, response, next) -> next new NotFoundError


exports["@require"] = ["errors/NotFoundError"]
exports["@singleton"] = true
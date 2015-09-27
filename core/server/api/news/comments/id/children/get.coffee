Controller = module.exports = (Comments) ->
  (request, response, next) ->
    Comments.findByParent request.params[0]
    .then (comments) -> response.json comments
    .catch (e) -> next e


Controller["@require"] = ["models/news/comments"]
Controller["@routes"] = ["/news/comments/([0-9]+)/children"]
Controller["@singleton"] = true
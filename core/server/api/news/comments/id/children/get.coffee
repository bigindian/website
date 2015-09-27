Controller = module.exports = (Comments) ->
  (request, response, next) ->
    Comments.findByParent request.params.id
    .then (comments) -> response.json comments
    .catch (e) -> next e


Controller["@require"] = ["models/news/comments"]
Controller["@routes"] = ["/news/comments/:id/children"]
Controller["@singleton"] = true
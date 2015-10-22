Controller = module.exports = (Stories, Report) ->
  (request, response, next) ->
    report =
      type: request.body.type
      content: request.body.content
      created_by: request.user.id

    response.json status: "reported"
    # Stories.get request.params.story
    # .then (model) -> model.report request.user.id
    # .then -> response.json status: "reported"
    # .catch (e) ->
    #   response.status 400
    #   response.json status: "already voted"


Controller["@middlewares"] = ["EnsureLoggedIn"]
Controller["@require"] = ["models/news/stories"]
Controller["@routes"] = ["/news/stories/:story/report"]
Controller["@singleton"] = true
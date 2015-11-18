Controller = module.exports = (Categories) ->
  (request, response, next) ->
    Categories.fetchAll().then (collection) ->  response.json collection
    .catch (e) -> next e


Controller["@require"] = ["models/news/categories"]
Controller["@routes"] = ["/news/categories"]
Controller["@singleton"] = true
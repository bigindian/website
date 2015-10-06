Controller = module.exports = (Users, NotFoundError) ->
  (request, response, next) ->
    Users.getByUsername request.params.slug
    .then (user) ->
      if not user? then throw new NotFoundError

      response.render "main/info/about",
        data: user
        # cache: enable: true
        metaRobots: "nofollow"
    .catch (e) -> next e


Controller["@require"] = [
  "models/users"
  "libraries/errors/NotFoundError"
  "models/news/comments"
]
Controller["@routes"] = ["/user/:slug"]
Controller["@singleton"] = true
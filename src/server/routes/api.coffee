express   = require "express"


exports = module.exports = (IoC) ->
  app = this
  router = express.Router()

  # These variable are only used to initialize the route. The number are used to
  # uniquely identify them in the switch statement in the function below.
  DELETE = 0
  GET = 1
  PATCH = 2
  POST = 3
  PUT = 4

  ###
    A helper function to initialize API routes. Because we want to avoid
    repetitive code, we use this function which shorten down things to nice
    clean statements.


    @param  String url           A regular expression string that matches the
                                 route
    @param  String controller    Local path of the api's controller (relative
                                 from the /controllers/api folder).
    @param  Number method        A number representing the type of request we
                                 should use.
  ###
  r = (url, controller, method=GET) ->
    api = (controller) -> IoC.create "api/#{controller}"
    switch method
      when POST
        router.post   (new RegExp "^#{url}/?$"), api "#{controller}/post"
      when PUT
        router.put    (new RegExp "^#{url}/?$"), api "#{controller}/put"
      when DELETE
        router.delete (new RegExp "^#{url}/?$"), api "#{controller}/delete"
      when GET
        router.get    (new RegExp "^#{url}/?$"), api "#{controller}/get"

  # r "",                                     ".",                         GET
  # r "/auth/email",                          "auth/email",                PUT
  # r "/auth/email/activate/([0-9]+)",        "auth/email/activate",       GET
  r "/auth/email/login",                    "auth/email/login",          POST
  r "/auth/email/signup",                   "auth/email/signup",         POST
  r "/auth/logout",                         "auth/logout",               GET
  r "/language/([a-z]+)",                   "language",                  GET
  r "/logs",                                "logs",                      GET
  r "/news",                                "/news",                      GET
  r "/news/categories",                     "/news/categories",           GET
  r "/news/comments",                       "/news/comments",             GET
  r "/news/comments/([0-9]+)",              "/news/comments/:id",         GET
  r "/news/comments/([0-9]+)/upvote",       "/news/comments/:id/upvote",  PUT
  r "/news/categories/counters",            "/news/categories/counters",  GET
  r "/news/recent",                         "/news/recent",               GET
  r "/news/scrape",                         "/news/scrape",               GET
  r "/news/stories",                        "/news/stories",              POST
  r "/news/stories/([0-9]+)",               "/news/stories/:id",          GET
  r "/news/stories/([0-9]+)/comments",      "/news/stories/:id/comments", GET
  r "/news/stories/([0-9]+)/comments",      "/news/stories/:id/comments", POST
  r "/news/stories/([0-9]+)/upvote",        "/news/stories/:id/upvote",   PUT
  r "/news/top",                            "/news/top",                  GET
  r "/users",                               "users",                      GET
  r "/users/([0-9]+)?",                     "users/:id",                  GET
  r "/users/current",                       "users/current",              GET
  r "/users/username/([0-9a-zA-Z\_]+)",     "users/username",             GET

  app.use "/api", router


exports["@require"] = ["$container"]
exports["@singleton"] = true


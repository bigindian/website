###
  This file is mainly responsible for setting up all the different routes for
  the App. You'll find routes for the Meetups, Forums and other components
  of the site get defined here.

  The routes here get defined by a function which takes care of any i18n
  issues. There is a helper function defined below (function route(..)) that
  is used to define all the routes. This function takes care of initializing
  the controller using electrolyte and automatically creates the regex version
  of the route.
###
express   = require "express"

exports = module.exports = (IoC, settings) ->
  app = this
  router = express.Router()


  ###
    Function to properly set the language based on the language slug. This
    function acts more as a custom middleware.

    @todo This function is not implemented as we don't really have i18n
    support yet.
  ###
  setLanguage = (request, response, next) ->
    # If the language cookie was not set, then set it.
    if not request.cookies["l"] then response.cookie "l", request.getLocale()
    # Read the cookies which sets the language.
    else response.setLocale request.cookies["l"]
    # Goto the next middleware.
    next()


  ###
    This helper function shortens the long line of writings routes and calling
    the dependency injector.

    @param  String url           The url to match
    @param  String controller    The controller to include
  ###
  route = (url, controller) ->
    if typeof controller is "string"
      controller = IoC.create "controllers/#{controller}"
    router.get (new RegExp "^#{url}/?$"), controller


  # Add route for each of the sub-pages
  route "",                                       "news/top"
  route "/categories",                            "news/categories"
  route "/login",                                 "auth/login"
  route "/login/forgot",                          "auth/login"
  route "/login/reset",                           "auth/login"
  route "/signup",                                "auth/signup"
  route "/category/([0-9a-z]+)/page/([0-9]+)",    "news/index"
  route "/category/([0-9a-z]+)?",                 "news/index"
  route "/comments",                              "news/index"
  route "/comments/page/([0-9]+)",                "news/index"
  route "/hottest",                               "news/index"
  route "/moderations",                           "news/index"
  route "/n/([0-9]+)",                            "news/redirector"
  route "/newest",                                "news/index"
  route "/newest/page/([0-9]+)?",                 "news/index"
  route "/page/([0-9]+)?",                        "news/top"
  route "/recent",                                "news/recent"
  route "/recent/page/([0-9]+)?",                 "news/recent"
  route "/rss",                                   "news/index"
  route "/search",                                "news/index"
  route "/stories",                               "news/index"
  route "/stories/preview",                       "news/index"
  route "/story/([a-z0-9\-]+)",                   "news/single"
  route "/submit",                                "news/submit"

  # If none of the routes matched, then route to the 404 controller!
  route ".*",            "errors/404"

  # Finally attach the router into the app
  app.use                router


exports["@require"] = [
  "$container"
  "igloo/settings"
]
exports["@singleton"] = true



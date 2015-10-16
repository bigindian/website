Router = module.exports = ($stateProvider, $locationProvider, $urlMatcher, $urlRouterProvider) ->
  # Disable strict mode to allow URLs with trailing slashes
  $urlMatcher.strictMode false

  # Helper function to create our routes
  index = 0
  _route = (page, route) ->
    templateUrl = "views/#{page}/template"
    $stateProvider.state "#{page}-#{index++}",
      controller: page
      page: page
      templateUrl: templateUrl
      url: route
      resolve:
        categories: ["@models/news/categories", (m) -> m.download()]
        user:       ["@models/users",           (m) -> m.download()]
        language:   ["@models/languages",       (m) -> m.download()]


  #! Start adding each route one by one
  _route "auth/login",         "/login"
  _route "auth/logout",        "/logout"
  _route "auth/login",         "/login/forgot"
  _route "auth/signup",        "/signup"

  _route "info/about",         "/info/about"
  _route "info/contribute",    "/info/contribute"
  _route "info/terms-privacy", "/info/terms-privacy"

  _route "news/categories",    "/categories"
  _route "news/filters",       "/filters"
  _route "news/category",      "/category/{cat:[^/]+}/recent"
  _route "news/category",      "/category/{cat:[^/]+}/recent/page/{page:[0-9]+}"
  _route "news/category",      "/category/{cat:[^/]+}"
  _route "news/category",      "/category/{cat:[^/]+}/page/{page:[0-9]+}"

  _route "news/comments",      "/comments"
  _route "news/comments",      "/comments/page/{page:[0-9]+}"
  _route "news/index",         ""
  _route "news/index",         "/page/{page:[0-9]+}"
  _route "news/newsletter",    "/newsletter"
  _route "news/recent",        "/recent"
  _route "news/recent",        "/recent/page/{page:[0-9]+}"
  _route "news/search",        "/search"
  _route "news/settings",      "/settings"
  _route "news/single",        "/story/{story:[^/]+}"
  _route "news/submit",        "/submit"

  _route "users/single",       "/user/{username:[^/]+}"

  _route "error/404",          "*page"


  #! Enable HTML5 pushstate for hash-less URLs
  $locationProvider.html5Mode
    enabled: true
    requireBases: false


Router.$inject = [
  "$stateProvider"
  "$locationProvider"
  "$urlMatcherFactoryProvider"
  "$urlRouterProvider"
]
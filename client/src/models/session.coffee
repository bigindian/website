Model = module.exports = ($location, $root, $log, $q, $resource, Users, Notifications, Api) ->
  logger = $log.init Model.tag


  new class Session
    ###
      The current user
    ###
    user: new Users.Model {}

    constructor: ->
      logger.log "initializing"

      @resource = $resource "/api/session", {},
        logout: method: "DELETE"
        login: method: "PUT"
        signup: method: "POST"


    refresh: ->
      @session ?= @resource.get({}).$promise.then (json={}) =>
        @user = new Users.Model json
        $root.bodyClasses["logged-in"] = not @user.isNew()
        $root.$broadcast "user:refresh"


    ###
      A simple function to perform a user-logout. Deletes the current session
      both locally and from the server.
    ###
    logout: -> @resource.logout().$promise


    ###
      Ensures that the user is loggedin. Use this in a promise chain.

      You can also pass in a set of options to customize this function's
      behaviour.
    ###
    ensureLogin: (options={}) -> new $q (resolve, reject) =>
      logger.info "user needs to be logged in for this page"
      if @user.isNew()
        if options.redirect
          Notifications.warn "login_needed"
          $location.search redirectTo: encodeURIComponent $location.url()
          $location.path "/login"

        reject()
      else resolve()


    ###
      Performs an API call to login the user using Email.
    ###
    login: (data, headers) ->
      @session = null
      @resource.login(data).$promise


    ###
      Performs an API call to signup the user using Email.
    ###
    signup: (data) ->
      @session = null
      @resource.signup(data).$promise


Model.tag = "model:session"
Model.$inject = [
  "$location"
  "$rootScope"
  "$log"
  "$q"
  "$resource"
  "@models/users"
  "@notifications"
  "@api"
]
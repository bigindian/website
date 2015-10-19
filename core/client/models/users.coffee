class User
  roles:
    NORMAL: 1
    MODERATOR: 2
    ADMIN: 3

  statuses:
    INACTIVE: 0
    ACTIVE: 1
    BANNED: 2
    SUSPENDED: 3

  defaults:
    login_providers: {}
    meta: {}
    personal: {}

  constructor: (data) -> @set data

  isAnonymous: -> not @user.id?

  isActive: -> @user.status is @statuses.ACTIVE
  isBanned: -> @user.status is @statuses.BANNED
  isInactive: -> @user.status is @statuses.INACTIVE
  isSuspended: -> @user.status is @statuses.SUSPENDED

  isAdmin: -> @user.role is @roles.ADMIN
  isModerator: -> @user.role is @roles.MODERATOR

  get: -> @user
  set: (data) ->
    @user = angular.extend {}, @defaults, data
    @id = @user.id




Model = ($http, $location, $root, $log, $q, Notifications, environment, storage) ->
  logger = $log.init Model.tag
  currentUser = new User
  downloadedFlag = false


  # Updates the current user
  updateUser = (response) ->
    logger.log "updating the current user"
    data = response.data
    downloadedFlag = false
    currentUser.set data
    $root.$broadcast "user:refresh", data
    $root.bodyClasses["logged-in"] = not currentUser.isAnonymous()
    response

  userURL = "#{environment.url}/api/users"
  authURL = "#{environment.url}/api/auth"


  class Users
    constructor: -> logger.log "initializing"

    # Returns the current user
    getCurrent: -> currentUser


    # Use these functions to check if a user is logged-in/logged-out
    isLoggedIn: -> not currentUser.isAnonymous()


    ###
      Get a user with the a specific id.

      @param  Number id          ID of the user to fetch from the API
      @return Promise            A promise that resolves with the HTTP response
    ###
    get: (id) -> $http.get "#{userURL}/#{id}"


    ###
      Re-downloads the user from the server.

      @return Promise           A promise that resolves once the current user
                                has been downloaded by the server.
    ###
    refresh: -> $http.get("#{userURL}/current").then updateUser



    findByUsername: (uname) -> $http.get "#{userURL}/username/#{uname}"


    ###
      A simple function to perform a user-logout. Deletes the current session
      both locally and from the server.

      @return Promise           A promise that resolves once the current
                                session has been destroyed by the server.
    ###
    logout: -> $http.get("#{authURL}/logout").then updateUser


    ###
      Download the current user from either the sessionStorage or from the API

      @return Promise          A promise that resolves once the current user
                               has been downloaded (from API/cache)..
    ###
    download: ->
      logger.log "downloading", downloadedFlag
      # This helper function is used to get the user details from the API
      fetchFromAPI = ->
        logger.log "downloading user"
        $http.get "#{userURL}/current"
        .then updateUser
        .then -> downloadedFlag = true

      ###
        Because this function gets called every-time we use a flag to avoid
        re-downloading the current user again. But sometimes because of the
        login/signup/logout events we want to re-download the user so we keep
        this flag global and clear it whenever needed.
      ###
      if not downloadedFlag
        downloadedFlag = true
        logger.log "retrieving current user from API"
        fetchFromAPI()
      else true


    withLogin: (options={}) -> new $q (resolve, reject) =>
      logger.info "user needs to be logged in for this page"
      if not @isLoggedIn()
        if options.redirect
          Notifications.warn "login_needed"
          $location.search redirectTo: encodeURIComponent $location.url()
          $location.path "/login"

        reject()
      else resolve()


    # Performs an API call to login the user using Email.
    login: (credentials, headers) ->
      $http
        data: credentials
        method: "POST"
        headers: headers
        url: "#{authURL}/email/login"
      .then updateUser


    getSettings: ->
      if @isLoggedIn() then settings = @getCurrent().get "settings"
      else
        settings =
          storyHideDomain: true
      settings


    # Performs an API call to signup the user using Email.
    signup: (details, headers) ->
      $http
        data: details
        method: "POST"
        headers: headers
        url: "#{authURL}/email/signup"
      .then updateUser


  new Users


Model.tag = "model:user"
Model.$inject = [
  "$http"
  "$location"
  "$rootScope"
  "$log"
  "$q"

  "@notifications"
  "@environment"
  "@storage"
]
module.exports = Model
NotificationService = ($http, $log, $location, storage, $timeout, Users,
Languages) ->

  class Notification
    constructor: ->
      @logger = $log.init NotificationService.tag
      @logger.log "initializing"


    # Returns a list of all the notifications
    getAll: ->


    _create: (message, type="success", timeout=5000) ->
      # $notifications.add
      #   hasRead: false
      #   flash: true
      #   message: message
      #   timeout: timeout
      #   type: type


    _translate: (token) ->
      # currentUser = Users.getCurrent() or {}
      # currentUserName = currentUser.get().full_name or ""
      # message = Languages.translate token
      # message.replace "_NAME_", currentUserName


    error: (message, timeout) -> @_create message, "error", timeout
    success: (message, timeout) -> @_create message, "success", timeout
    warn: (message, timeout) -> @_create message, "warn", timeout

    parseURL: ->
      @logger.log name, "parsing URL"
      query = $location.search()
      if query._success? then @success @_translate query._success
      if query._error? then @error @_translate query._error
      if query._warn? then @warn @_translate query._warn
      $timeout ->
        $location.search "_error", null
        $location.search "_success", null
        $location.search "_warn", null
      , 1000


  new Notification



NotificationService.tag = "service:notifications"
NotificationService.$inject = [
  "$http"
  "$log"
  "$location"
  "$timeout"
  "@storage"
  "@models/languages"
  "@models/users"
]
module.exports = NotificationService
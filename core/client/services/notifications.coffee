NotificationService = module.exports = ($log, $root) ->
  logger = $log.init NotificationService.tag
  logger.log "initializing"


  _create = (message, type="success", timeout=5000) ->
    notification =
      message: message
      show: true
      type: type

    $root.$emit "notifications:add", notification


  class Service
    @error: (message, timeout) ->   _create message, "error", timeout
    @success: (message, timeout) -> _create message, "success", timeout
    @warn: (message, timeout) ->    _create message, "warn", timeout


NotificationService.tag = "service:notifications"
NotificationService.$inject = [
  "$log"
  "$rootScope"
]
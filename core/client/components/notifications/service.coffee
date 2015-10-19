Service = module.exports = ($log, $root) ->
  logger = $log.init Service.tag
  logger.log "initializing"


  class Service

    _create: (message, type="success", timeout=5000) ->
      notification =
        message: message
        show: true
        type: type

      $root.$emit "notifications:add", notification


    error: (message, timeout) ->   @_create message, "error", timeout
    success: (message, timeout) -> @_create message, "success", timeout
    warn: (message, timeout) ->    @_create message, "warn", timeout


  new Service


Service.tag = "service:notifications"
Service.$inject = [
  "$log"
  "$rootScope"
]
Controller = module.exports = ($scope, $log) ->
  logger = $log.init Controller.tag
  logger.log "initialized"


Controller.tag = "component:footer:subscription-modal"
Controller.$inject = [
  "$scope"
  "$log"
]
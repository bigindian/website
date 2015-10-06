EventHandler = ($anchorScroll, $log, $root, $timeout) ->
  logger = $log.init EventHandler.tag
  logger.log "initialized"

  $root.$on "page:start", (event) ->
    logger.log "captured event!"

    # Remove the loading class, so that loading bar gets hidden away.
    $timeout(250).then -> $root.bodyClasses.loading = false

    $timeout(250).then -> $anchorScroll()


EventHandler.tag = "event:pageStart"
EventHandler.$inject = [
  "$anchorScroll"
  "$log"
  "$rootScope"
  "$timeout"
]
module.exports = EventHandler
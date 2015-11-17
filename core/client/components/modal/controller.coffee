Controller = module.exports = ($sce, $log, $root, $scope, $timeout) ->
  logger = $log.init Controller.tag
  logger.log "initializing"

  currentModal = null
  scrollPosition = 0

  $scope.$on "modal:show", ($event, modal) ->
    logger.log "opening modal"
    logger.debug modal

    scrollPosition = document.body.scrollTop

    if currentModal? then currentModal.kill()

    $root.bodyClasses["stop-scrolling"] = true
    $root.bodyClasses["show-modal"] = true
    currentModal = modal


  $scope.close = ->
    logger.log "closing modal"

    $root.bodyClasses["show-modal"] = false
    $root.bodyClasses["stop-scrolling"] = false

    $timeout(100).then -> document.body.scrollTop = scrollPosition

    if currentModal? then currentModal.kill()
    currentModal = null

  $scope.$on "modal:close", -> $scope.close()


Controller.tag = "component:modal"
Controller.$inject = [
  "$sce"
  "$log"
  "$rootScope"
  "$scope"
  "$timeout"
]
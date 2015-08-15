EventHandler = ($root, $log, $timeout, Environment, Language) ->
  logger = $log.init EventHandler.tag
  logger.log "initialized"

  $root.bodyClasses ?= {}
  stateClasses = null


  $root.$on "$stateChangeStart",
    (event, toState, toParams, fromState, fromParams) ->

      logger.log "captured event!"
      logger.log "switching #{fromState.name} -> #{toState.name}"
      if stateClasses then $root.bodyClasses[stateClasses] = false

      # Set the loading class on the page
      $root.bodyClasses.loading = true

      # Give a proper id & class to the <body> tag
      document.body.id = toState.page.replace /\//g, "-"
      stateClasses = toState.page.replace /\//g, " "
      $root.bodyClasses[stateClasses] = true


EventHandler.tag = "event:stateChangeStart"
EventHandler.$inject = [
  "$rootScope"
  "$log"
  "$timeout"
  "@environment"
  "@models/languages"
]
module.exports = EventHandler
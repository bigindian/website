EventHandler = ($root, $log, $timeout, Environment, Language) ->
  logger = $log.init EventHandler.tag
  logger.log "initialized"

  $root.bodyClasses ?= {}
  stateClasses = null


  $root.$on "$stateChangeStart",
    (event, toState, toParams, fromState, fromParams) ->
      setTitle = ->
        title = Language.translate "title", toState.page
        if title == "" then document.title = "#{Environment.sitename}"
        else document.title = "#{title} - #{Environment.sitename}"


      $root.$on "model:language:change", setTitle
      setTitle()


      # document.title =
      logger.log "captured event!"
      logger.log "switching #{fromState.name} -> #{toState.name}"
      if stateClasses then $root.bodyClasses[stateClasses] = false

      $root.$on

      # Set the loading class on the page
      $root.bodyClasses.loading = true

      # Give a proper id & class to the <body> tag
      if (controller = toState.controller)?
        document.body.id = controller.replace /\//g, "-"
        stateClasses = controller.replace /\//g, " "
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
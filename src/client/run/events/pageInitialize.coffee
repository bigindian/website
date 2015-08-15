exports = module.exports = ($ga, $location, $log, $root, $timeout, Users) ->
  logger = $log.init "event:pageStart"
  logger.log "initialized"

  body = document.body

  $root.$on "page:initialize", (event, value={}) ->
    logger.log "captured event!"

    if value.needLogin and not Users.isLoggedIn()
      logger.info "user needs to be logged in for this page"
      url = $location.url()
      $location.search
        redirectTo: url
        _warn: "need_login"
      $location.path "/login"

    # # Set the header's backbutton accordingly.. FIXTHIS
    # $root.bodyClasses["show-header-backbutton"] = historyIndex++ > 0 and
    # not value.basePage

    # Send a pageview in google analytics
    $ga.sendPageView()


exports.$inject = [
  "$google/analytics"
  "$location"
  "$log"
  "$rootScope"
  "$timeout"
  "@models/users"
]
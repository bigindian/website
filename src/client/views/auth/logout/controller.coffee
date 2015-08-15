Controller = ($location, $log, Notifications, Users) ->
  logger = $log.init Controller.tag
  logger.log "initializing"


  Notifications.success "logout_success"
  $location.path "/"
  Users.logout()


Controller.tag = "page:auth/logout"
Controller.$inject = [
  "$location"
  "$log"
  "@notifications"
  "@models/users"
]
module.exports = Controller
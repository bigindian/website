Controller = ($location, $log, Users) ->
  logger = $log.init Controller.tag
  logger.log "initializing"

  $location.path "/"
  Users.logout()


Controller.tag = "page:auth/logout"
Controller.$inject = [
  "$location"
  "$log"
  "@models/users"
]
module.exports = Controller
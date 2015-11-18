Controller = module.exports = ($scope, $root, $log, $timeout, $location, angular, ModalGenerator, Users) ->
  logger = $log.init Controller.tag
  logger.log "initialized"


  $root.$on "page:feeds", (event, data) -> $scope.feeds = data



Controller.tag = "component:header:sources-modal"
Controller.$inject = [
  "$scope"
  "$rootScope"
  "$log"
  "$timeout"
  "$location"
  "angular"
  "@modalGenerator"
  "@models/users"
]
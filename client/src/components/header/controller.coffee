Controller = module.exports = ($scope, $root, $log, $mdSidenav, angular) ->
  logger = $log.init Controller.tag
  logger.log "initialized"

  $scope.showSidenav = -> $mdSidenav("sidenav").toggle()


Controller.tag = "component:header"
Controller.$inject = [
  "$scope"
  "$rootScope"
  "$log"
  "$mdSidenav"
  "angular"
]
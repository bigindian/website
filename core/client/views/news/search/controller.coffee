Controller = ($scope, $log) ->
  logger = $log.init Controller.tag
  logger.log "initializing"
  $scope.$emit "page:initialize"
  $scope.$emit "page:start"


Controller.tag = "page:news/search"
Controller.$inject = [
  "$scope"
  "$log"
]
module.exports = Controller
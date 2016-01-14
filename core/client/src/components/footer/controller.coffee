Controller = module.exports = ($scope, $root, $log, $timeout, $location, angular, ModalGenerator, Users) ->
  logger = $log.init Controller.tag
  logger.log "initialized"

  subscriptionModal = new ModalGenerator
    controller: require "./subscription-modal/controller"
    templateUrl: "components/footer/subscription-modal/template"
  $scope.showSubscriptionModal = -> subscriptionModal.show()
  # $timeout(100).then -> $scope.showSubscriptionModal()


Controller.tag = "component:footer"
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
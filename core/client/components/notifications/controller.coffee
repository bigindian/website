Controller = module.exports = ($sce, $log, $root, $scope, $timeout) ->
  logger = $log.init Controller.tag
  logger.log "initializing"
  $scope.notifications = []

  # Use this to adjust how long the flash notifications stay on the header,
  # before they disappear.
  lifetime = 7 * 1000

  # Listen for a notification event to add the a flash notification
  $root.$on "notifications:add", (event, data) ->
    notification = data
    notification.message = $sce.trustAsHtml data.message or ""
    notification.class = {}
    notification.class[notification.type] = true

    $scope.notifications.push notification

    $timeout(10).then -> notification.class["animate-in"] = true

    # Set a timeout function to remove the notification
    do (notification) -> $timeout(lifetime).then -> $scope.read notification

    # Helper function to remove a notification
    $scope.read = (notification) ->
      # First let CSS animate it out
      notification.class["animate-in"] = false
      notification.class["animate-out"] = false

      # Then remove it from the stack by marking it as read.
      $timeout(1000).then -> notification.hasRead = true


Controller.tag = "component:notification"
Controller.$inject = [
  "$sce"
  "$log"
  "$rootScope"
  "$scope"
  "$timeout"
]
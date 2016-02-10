Controller = module.exports = ($http, $log, $scope, $toast, $window, $root, $mdDialog, Stories) ->
  logger = $log.init Controller.tag
  logger.log "initializing"
  $scope.$emit "page:initialize"

  $scope.showCommentsModal = ->
    $mdDialog.show
      clickOutsideToClose: true
      controller: require "./new-comment-modal/controller"
      fullscreen: true
      templateUrl: "views/news/single/new-comment-modal/template"

  $http.pageAsJSON().success (data) ->
    logger.debug data
    $scope.model = new Stories.Model data

    $root.bodyClasses["with_image"] = data.image_url
    if data.image_url
      $root.bodyStyles = {
        backgroundImage: "url(#{ data.image_url })"
        backgroundRepeat: "no-repeat"
        backgroundPosition: "center center"
        backgroundAttachment: "fixed"
      }

    $scope.model.categories = [
      "space"
      "finance"
      "innovative"
    ]
    $scope.$emit "page:start"


  $scope.goBack = -> $window.history.back()


Controller.tag = "page:news/single"
Controller.$inject = [
  "$http"
  "$log"
  "$scope"
  "$mdToast"
  "$window"
  "$rootScope"
  "$mdDialog"
  "@models/news/stories"
]
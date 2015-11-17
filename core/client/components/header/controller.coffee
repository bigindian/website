Header = module.exports = ($scope, $root, $log, $timeout, $location, angular, ModalGenerator, Users) ->
  logger = $log.init Header.tag
  logger.log "initialized"

  # Allow upto 'X' unread notifications to be put in the sub-header
  maxUnreadNotifications = 3

  $outerScope = $scope

  sourcesModal = new ModalGenerator
    controller: ($scope) -> $scope.feeds = require "./feeds.json"
    templateUrl: "components/header/sources-modal/template"
  $scope.showSourcesModal = -> sourcesModal.show()


  $scope.activeLink = null

  $root.$on "$viewContentLoaded", ->
    try $scope.route = $location.path().split("/")[1] or ""
    catch e then $scope.route = ""

  $root.$on "page:feeds", (event, data) ->
    $scope.feeds = data

  $scope.$on "model:language:change", ->
    $scope.links = angular.fromJson angular.toJson $scope.links
    setActiveLinks()


  $scope.onMainLinkHover = (link) ->
    if $scope.activeLink? then $scope.activeLink.isActive = false
    if not link.children? then return $scope.showSubMenu = false
    link.isActive = true
    $scope.showSubMenu = true
    $scope.mainBorderColor = link.color
    $scope.activeLink = link


  $scope.onCoverHover = ->
    $scope.showSubMenu = false
    if $scope.activeLink? then $scope.activeLink.isActive = false


  onHeaderChange = -> setActiveLinks()

  onHeaderClose = ->
    $scope.showMenuHeader = false
    $scope.showSubMenu = false
    $scope.$broadcast "hamburger:close"
    if $scope.activeLink? then $scope.activeLink.isActive = false
    onHeaderChange()

  onHeaderOpen = ->
    $scope.$broadcast "hamburger:open"
    onHeaderChange()


  $scope.showSubMenu = false
  $scope.links = require "./links.json"

  setActiveLinks = ->
    url = $location.url()
    evaluate = (l) -> l.isActive = url.indexOf(l.url) is 0 and l.url != "/"
    for link in $scope.links
      evaluate link
      evaluate childLink for childLink in link.children or []
      if link.isActive then $scope.currentPageLink = link


  # A click handler to display the sub header
  $scope.openHeader = ->
    $scope.showMenuHeader = true
    onHeaderOpen()


  # A click handler to hide the sub header.
  $scope.closeHeader = -> onHeaderClose()


  $root.$on "$stateChangeStart", $scope.closeHeader
  $scope.$watch "showMenuHeader", (v) -> $root.bodyClasses["show-header"] = v
  $scope.$watch "showSubMenu", (v) -> $root.bodyClasses["show-subheader"] = v


  # This click handler is used to toggle (display/hide) the subheader.
  $scope.toggleHeader = ->
    if $scope.showMenuHeader then $scope.closeHeader()
    else $scope.openHeader()



  $scope.$on "user:refresh", (event, user) -> $scope.user = user


  $scope.headerLogoClick = ->
    if not $root.bodyClasses["show-header-backbutton"] then $location.path "/"
    else history.back()


Header.tag = "component:header"
Header.$inject = [
  "$scope"
  "$rootScope"
  "$log"
  "$timeout"
  "$location"
  "angular"
  "@modalGenerator"
  "@models/users"
]
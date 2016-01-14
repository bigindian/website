Controller = module.exports = ($scope, $element, $timeout) ->
  bricks = {}
  schedule = []
  destroyed = false
  timeout = null
  @preserveOrder = false
  @loadImages = false


  defaultLoaded = ($element) -> $element.addClass "loaded"


  @scheduleMasonryOnce = ->
    args = arguments
    found = schedule.filter((item) -> item[0] == args[0]).length > 0
    if !found then @scheduleMasonry.apply null, arguments


  # Make sure it"s only executed once within a reasonable time-frame in
  # case multiple elements are removed or added at once.
  @scheduleMasonry = ->
    if timeout then $timeout.cancel timeout
    schedule.push [].slice.call arguments
    timeout = $timeout ->
      if destroyed then return
      schedule.forEach (args) -> $element.packery.apply $element, args
      schedule = []
    , 100


  @appendBrick = (element, id) ->
    _append = ->
      if Object.keys(bricks).length == 0 then $element.packery "resize"
      if not bricks[id]?
        # Keep track of added elements.
        bricks[id] = true
        defaultLoaded element
        $element.packery "appended", element, true

    _layout = =>
      # I wanted to make this dynamic but ran into huuuge memory leaks
      # that I couldn't fix. If you know how to dynamically add a
      # callback so one could say <packery loaded="callback($element)">
      # please submit a pull request!
      @scheduleMasonryOnce "layout"

    if destroyed then return
    if not @loadImages
      _append()
      _layout()
    else if @preserveOrder
      _append()
      element.imagesLoaded _layout
    else
      element.imagesLoaded ->
        _append()
        _layout()


  @removeBrick = (id, element) ->
    if destroyed then return
    delete bricks[id]
    $element.packery "remove", element
    @scheduleMasonryOnce "layout"


  @destroy = ->
    destroyed = true

    # Gently uninitialize if still present
    if $element.data "packery" then $element.packery "destroy"
    $scope.$emit "packery.destroyed"
    bricks = {}


  @reload = ->
    $element.packery()
    $scope.$emit "packery.reloaded"


  this


Controller.$inject = [
  "$scope"
  "$element"
  "$timeout"
]
module.exports = ->
  restrict: "AC"
  require: "^packery"
  scope: true
  link:
    pre: (scope, element, attributes, controller) ->
      id = scope.$id
      controller.appendBrick element, id

      element.on "$destroy", -> controller.removeBrick id, element

      scope.$on "packery.reload", ->
        controller.scheduleMasonryOnce "reloadItems"
        controller.scheduleMasonryOnce "layout"

      scope.$watch "$index", ($index) ->
        if scope.prevIndex? and scope.prevIndex != $index
          controller.scheduleMasonryOnce "reloadItems"
          controller.scheduleMasonryOnce "layout"
        scope.prevIndex = $index
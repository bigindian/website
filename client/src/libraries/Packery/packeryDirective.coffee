module.exports = ->
  restrict: "AEC"
  controller: "PackeryController"
  link:
    pre: (scope, element, attributes, controller) ->
      attributeOptions = scope.$eval attributes.packery or attributes.packeryOptions

      options = window.angular.extend
        itemSelector: attributes.itemSelector or ".packery-brick"
        columnWidth: parseInt(attributes.columnWidth, 10) or attributes.columnWidth
      , attributeOptions or {}


      element.packery options
      window.a = element
      scope.packeryContainer = element[0]

      loadImages = scope.$eval attributes.loadImages
      controller.loadImages = loadImages or false

      preserveOrder = scope.$eval attributes.preserveOrder
      controller.preserveOrder = preserveOrder or false


      reloadOnShow = scope.$eval attributes.reloadOnShow
      if reloadOnShow and attributes.reloadOnShow?
        scope.$watch (watch = -> element.prop "offsetParent"),
          (isVisible, wasVisible) ->
            if isVisible and !wasVisible then controller.reload()

      reloadOnResize = scope.$eval attributes.reloadOnResize
      if reloadOnResize and attributes.reloadOnResize?
        scope.$watch "packeryContainer.offsetWidth",
          offsetWidthWatch = (newWidth, oldWidth) ->
            if newWidth != oldWidth then controller.reload()

      scope.$emit "packery.created", element
      scope.$on "$destroy", controller.destroy
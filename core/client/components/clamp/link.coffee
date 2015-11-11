module.exports = ($timeout, angular) ->
  createElement = ->
    tagDiv = document.createElement "div"

    do (s=tagDiv.style) ->
      s.display = "inline-block"
      s.position = "absolute"
      s.visibility = "hidden"
      s.whiteSpace = "pre"

    angular.element tagDiv


  resetElement = (element, type) ->
    element.css
      display: "block"
      overflow: "hidden"
      position: "inherit"
      textOverflow: if type then "ellipsis" else "clip"
      visibility: "inherit"
      whiteSpace: "nowrap"
      width: "100%"


  linkDirective = (scope, element, attrs) -> $timeout ->
    lineCount = 1
    lineMax = +attrs.clamp
    lineStart = 0
    lineEnd = 0
    text = element.html().replace /\n/g, " "
    maxWidth = element[0].offsetWidth
    estimateTag = createElement()
    element.empty()
    element.append estimateTag
    text.replace RegExp(" ", "g"), (m, pos) ->
      if lineCount >= lineMax then return
      else
        estimateTag.html text.slice lineStart, pos
        if estimateTag[0].offsetWidth > maxWidth
          estimateTag.html text.slice lineStart, lineEnd
          resetElement estimateTag
          lineCount++
          lineStart = lineEnd + 1
          estimateTag = createElement()
          element.append estimateTag
        lineEnd = pos

    estimateTag.html text.slice lineStart
    resetElement estimateTag, true
    scope.$emit "clampCallback", element, attrs
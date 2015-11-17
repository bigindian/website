Controller =  module.exports = ($scope, $log, $timeout, $window, Settings, Articles) ->
  logger = $log.init Controller.tag
  logger.log "initializing"

  article = null

  $scope.$watch "_original", (value) ->
    if value not instanceof Articles.Model
      article = $scope.article = new Articles.Model value
    else article = $scope.article = value
    feed = $scope.feed

    article.popular = 2 < article.get "clicks_count"

    if feed?
      meta = feed.get "meta"
      $scope.borderColor = if meta.isWhite then "#666" else feed.get "color"

    # Decide if the article is new. (published_at < 20min <=> isNew = true)
    article_created = new Date article.get "published_at"
    old_news = new Date Date.now() - 20 * 60000 # 20 minutes from now
    article.isNew = article_created > old_news

    setTimeout (-> $scope.$emit "packery.reload"), 500


  $scope.onHover = ($event) ->
    centerX = $window.innerWidth / 2
    centerY = $window.innerHeight / 2
    clientX = $event.clientX
    clientY = $event.clientY

    if clientX < centerX and clientY < centerY # 1st quadrant
      style = top: "150%", left: "30%"
    else if clientX >= centerX and clientY < centerY # 2nd quadrant
      style = top: "150%", right: "30%"
    else if clientX < centerX and clientY >= centerY # 3rd quadrant
      style = bottom: "150%", left: "30%"
    else if clientX >= centerX and clientY >= centerY # 4th quadrant
      style = bottom: "150%", right: "30%"
    $scope.excerptStyle = style

    $scope.timeout = $timeout ->
      article.image_url_masked = article.get "image_url"
    , 500


  $scope.onLeave = ->
    article.image_url_masked = ""
    if $scope.timeout? then $timeout.cancel $scope.timeout


Controller.tag = "component:news-feed-item"
Controller.$inject = [
  "$scope"
  "$log"
  "$timeout"
  "$window"
  "@settings"
  "@models/news/articles"
]
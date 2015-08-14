exports = module.exports = ($scope, $root, $cookies, $log, $http, Categories) ->
  name = "[page:news/categories]"
  $log.log name, "initializing"

  # Setup variables. use 'f' as the key to store the filter attributes.
  cookiesKey = "f"
  $scope.filters = {}

  # Read the blocked categories from our encoded cookie!
  cookiesFilterString = $cookies.get(cookiesKey) or ""
  for key in cookiesFilterString.split "-"
    if key.length > 0 then $scope.filters[key] = true

  # Fetch data from the page.
  $http.pageAsJSON().success (data) ->
    categories = $scope.categories = data.categories or []
    counters = data.counters or []

    for cat in $scope.categories then for counter in counters
      if cat.id is counter.category then cat.counter = counter.stories

    $scope.$emit "page:loaded"

  # Save the filters.
  $scope.saveFilters = (filters) ->
    cookieString = ""
    for id of filters then if filters[id] then cookieString += "#{id}-"
    $cookies.put cookiesKey, cookieString


exports.$inject = [
  "$scope"
  "$rootScope"
  "$cookies"
  "$log"
  "$http"
  "models.news.categories"
]

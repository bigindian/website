module.exports = ($log, $window, $injector) ->
  exceptionHandler = (exception) -> console.error exception.stack
exports = module.exports = ($provide) ->
  decorator = ($delegate, $sniffer, $window) ->
    originalGet = $delegate.get

    class CustomLogger
      constructor: (tag) -> @tag = "[#{tag}]"

      _perform: (fn, args=[]) ->
        args = [].slice.call args
        args.unshift @tag # Prepend tag
        fn.apply $delegate, args # Call the original function

      debug: -> @_perform $delegate.debug, arguments
      error: -> @_perform $delegate.error, arguments
      log: -> @_perform $delegate.log, arguments
      trace: -> @_perform $delegate.trace, arguments
      warn: -> @_perform $delegate.warn, arguments

    $delegate.init = (tag) -> new CustomLogger tag
    $delegate


  decorator.$inject = [
    "$delegate"
    "$sniffer"
    "$window"
  ]
  $provide.decorator "$log", decorator


exports.$inject = ["$provide"]

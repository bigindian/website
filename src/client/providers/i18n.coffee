exports = module.exports = -> new class
  name = "[provider:i18n]"
  console.log name, "dfi"

  ###
    This function is called by Angular when this provider is first invoked.
  ###
  $get: [
    "$window"
    "$log"
    "$base64"
    "$timeout"
    ($window, $log, $base64, $timeout) ->
      $log.log name, "initializing"
      $log.log name, "decoding server-side data"

      $timeout 1000
      .then ->
        console.debug name, "dnoe"
        {}
      # try
      #   config = {}
      #   # Decode the cryptedData and extend the properties of the publicData
      #   # object
      #   angular.extend config, $window.publicData,
      #     angular.fromJson $base64.decode $window.cryptedData
      #   @config = config
      #   return config
      # catch e
      #   $log.error name, "error decoding server-side data"
      #   $log.error e
      #   return {}
  ]

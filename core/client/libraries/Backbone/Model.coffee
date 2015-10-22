NgBackboneModel = module.exports = ($rootScope, Backbone, _) ->
  defineProperty = (key) ->
    Object.defineProperty @$attributes, key,
      enumerable: true
      configurable: true
      get: => @get key
      set: (newValue) => @set key, newValue


  Backbone.Model.extend
    constructor: ->
      @$status =
        deleting: false
        loading: false
        saving: false
        syncing: false

      @on "request", (model, xhr, options) ->
        @$setStatus
          deleting: options.method == "DELETE"
          loading: options.method == "GET"
          saving: options.method == "POST" or options.method == "PUT"
          syncing: true

      @on "sync error", @$resetStatus
      Backbone.Model.apply this, arguments


    set: (key, val, options) ->
      output = Backbone.Model::set.apply this, arguments
      # Do not set binding if attributes are invalid
      if output then @$setBinding key, val, options
      output


    $resetStatus: ->
      @$setStatus
        deleting: false
        loading: false
        saving: false
        syncing: false


    $setBinding: (key, val, options={}) ->
      if _.isUndefined key then return this
      if _.isObject key
        attrs = key
        options = val
      else (attrs = {})[key] = val

      if _.isUndefined @$attributes then @$attributes = {}

      unset = options.unset
      for attr of attrs
        if unset and @$attributes.hasOwnProperty attr
          delete @$attributes[attr]
        else if !unset and !@$attributes[attr]
          defineProperty.call this, attr

      this


    $setStatus: (key, value, options={}) ->
      if _.isUndefined key then return this
      if _.isObject key
        attrs = key
        options = value
      else (attrs = {})[key] = value

      for attr of @$status
        if attrs.hasOwnProperty(attr) and _.isBoolean attrs[attr]
          @$status[attr] = attrs[attr]


    $removeBinding: (attr, options) ->
      @$setBinding attr, undefined, _.extend {}, options, unset: true


NgBackboneModel.$inject = [
  "$rootScope"
  "Backbone"
  "underscore"
]
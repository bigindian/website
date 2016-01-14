BackboneCollection = module.exports = (Backbone, BackboneModel, _) ->
  Backbone.Collection.extend
    model: BackboneModel
    constructor: ->
      # Initialize status object
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

      # For clearing status when destroy model on collection
      @on "destroy", @$resetStatus
      Object.defineProperty this, "$models",
        enumerable: true
        get: => @models

      Backbone.Collection.apply this, arguments


    $setStatus: (key, value, options={}) ->
      if _.isUndefined key then return this
      if _.isObject key
        attrs = key
        options = value
      else (attrs = {})[key] = value

      for attr of @$status
        if attrs.hasOwnProperty(attr) and
        _.isBoolean attrs[attr]
          @$status[attr] = attrs[attr]


    $resetStatus: ->
      @$setStatus
        deleting: false
        loading: false
        saving: false
        syncing: false



BackboneCollection.$inject = [
  "Backbone"
  "BackboneModel"
  "underscore"
]
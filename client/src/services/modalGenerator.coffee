###
Taken from https://github.com/btford/angular-modal
###

ModalFactoryGenerator = module.exports = ($animate, $compile, $rootScope, $controller, $q, $http, $templateCache, angular) ->
  class Modal
    constructor: (config) ->
      if not (!config.template ^ !config.templateUrl)
        throw new Error "Expected modal to have exacly one of either `template` or `templateUrl`"
      template = config.template
      @raw_controller = config.controller or null
      @container = angular.element document.getElementById("modal-content") or document.body

      # Get the template!
      if config.template then html = $q.when config.template
      else
        $http.get config.templateUrl, cache: $templateCache
          .then (response) => @html = response.data


    show: (locals={})->
      if @element? then return #logger.log "modal is already shown"

      @element = angular.element @html

      if @element.length is 0
        throw new Error "The template contains no elements"

      @scope = $rootScope.$new()
      if @raw_controller
        locals.$scope = @scope
        @controller = $controller @raw_controller, locals

      else @scope[prop] = locals[prop] for prop of locals

      $compile(@element) @scope
      $animate.enter @element, @container

      console.log @element
      $rootScope.$emit "modal:show", this


    hide: -> @kill().then => $rootScope.$emit "modal:hide", this


    kill: ->
      if not @element? then return $q.when()
      $animate.leave @element
      .then =>
        # Destroy the scope
        @scope.$destroy()
        @scope = null

        # Destroy the element
        @element.remove()
        @element = null


    isShown: -> @element?


ModalFactoryGenerator.$inject = [
  "$animate"
  "$compile"
  "$rootScope"
  "$controller"
  "$q"
  "$http"
  "$templateCache"
  "angular"
]
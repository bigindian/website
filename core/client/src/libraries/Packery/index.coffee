module.exports = (app) ->
  app.controller "PackeryController", require "./packeryController"
  app.directive  "packery",           require "./packeryDirective"
  app.directive  "packeryBrick",      require "./packeryBrickDirective"
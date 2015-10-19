_ = require "underscore"
_.mixin deepExtend: (require "underscore-deep-extend") _


Config = module.exports = ->
  defaults = require "./environment/default"        # Default options
  test = require "./environment/test"               # Testing-specific options
  development = require "./environment/development" # Development-specific options
  production = require "./environment/production"   # Production specific options
  oAuth = require "./privateKeys.json"              # Private production keys

  {
    defaults: _.deepExtend {}, defaults, oAuth
    test: test
    development: development
    production: production
  }


Config["@singleton"] = true
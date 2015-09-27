Config = module.exports = ->
  # Default options
  defaults: require "./environment/default"

  # Testing-specific options
  test: require "./environment/test"

  # Development-specific options
  development: require "./environment/development"

  # Production specific options
  production: require "./environment/production"


Config["@singleton"] = true
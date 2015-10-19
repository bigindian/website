module.exports = ->
  properties:
    createConfig:
      description: "Do you want to automatically generate a configuration file? (y/n):".yellow
      required: true
      pattern: /^[yn]/
      message: "please enter y or n"
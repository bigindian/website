module.exports = ->
  properties:
    email:
      description: "Do you want to enable email? (y/n):".yellow
      required: true
      pattern: /^[yn]/
      message: "please enter y or n"

    recaptcha:
      description: "Do you want to enable Google reCaptcha? (y/n):".yellow
      required: true
      pattern: /^[yn]/
      message: "please enter y or n"

    analytics:
      description: "Do you want to enable Google analytics? (y/n):".yellow
      required: true
      pattern: /^[yn]/
      message: "please enter y or n"

    analyticsCode:
      description: "Type in the Google analytics code (UX-XXXXXXXXX):".yellow
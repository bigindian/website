Promise = require "bluebird"
fs      = Promise.promisifyAll require "fs"
path    = require "path"

prompt  = require "./_getPrompter"
schema  = require("./_questions1")()


configfile = path.join __dirname, "../privateKeys.json"
knexfile = path.join __dirname, "../knexfile.coffee"
sampleKnexfile = path.join __dirname, "../knexfile.coffee"


fs.exists configfile, (exists) ->
  if exists then console.log "[*] configuration exists!".green
  else console.log "[X] configuration not found!".red

  if not exists
    prompt.get schema, (error, result) ->
      if error then return onError error
      if result.createConfig != "y" then return

      console.log "[*] Creating configuration file"

      schema = require("./_questions2")()

      prompt.get schema, (error, result) ->
        if error then return onError error

        config = require("./_getSample")()

        if result.analytics is "y"
          config.analyticsCode = result.analyticsCode

        fs.writeFile configfile, JSON.stringify config, " ", 2

        console.log "[*] configuration file created".green
        console.log "[!] you'll have to modify #{configfile} accordingly".green.bold

        setupKnex()
  else setupKnex()


setupKnex = ->
  fs.exists knexfile, (exists) ->
    if exists then return console.log "[*] knexfile exists!".green
    else console.log "[X] knexfile is not found!".yellow


onError = (error) ->
  console.log error
  return 1
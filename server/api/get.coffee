pos = require('pos')
MetaInspector = require "node-metainspector"
Promise       = require "bluebird"
Request       = require "request"
_             = require "underscore"
colorThief    = require "color-thief"
fs            = require "fs"
gm            = require "gm"
htmlToText    = require "html-to-text"
normalizeUrl  = require "normalize-url"
read          = require "node-readability"
slug          = require "slug"
# Boilerpipe    = require "boilerpipe"


fetchInformationWithRead = (url) -> new Promise (resolve, reject) ->
  read url, (error, article, meta) ->
    if error then return reject error

    text = htmlToText.fromString article.content,
      hideLinkHrefIfSameAsText: true
      ignoreHref: true
      ignoreImage: true

    resolve text


blah = (text="") ->
  words = (new (pos.Lexer)).lex text.toLowerCase()
  tagger = new pos.Tagger
  taggedWords = tagger.tag words

  selected = {}

  for taggedWord in taggedWords
    word = taggedWord[0]
    tag = taggedWord[1]

    if tag in ["NN", "NNP", "NNPS"] and /^[a-z0-9]{2,}$/.test word
      selected[word] ?= count: 0
      selected[word].count += 1
      selected[word].tag = tag
      selected[word].word = word


  selected = _.reject selected, (word) -> word.count <= 1
  console.log _.sortBy selected, (word) -> word.count


Controller = module.exports = (settings) ->
  # fetchInformationWithRead "http://yourstory.com/2016/02/uncool-non_tech-company-era/"
  # .then blah

  (request, response, next) ->
    data =
      version: "2.0.0"
      authors: [
        "Steven Enamakel"
      ]
      description: "This is the API for communicating with all frontend apps"
      md5: settings.md5
      androidVersion: settings.androidVersion
      status: "online"
    response.json data



Controller["@require"] = [
  "igloo/settings"
  "libraries/boilerpipe"
]
Controller["@routes"] = [""]
Controller["@singleton"] = true
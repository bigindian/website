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


getKeywords = (text="") ->
  tagger = new pos.Tagger
  selected = {}

  # First get all the words.
  words = (new (pos.Lexer)).lex text.toLowerCase()

  # Tag the words and iterate through each of them.
  for taggedWord in tagger.tag words
    word = taggedWord[0]
    tag = taggedWord[1]

    # Regex to test the word against. This ensures that we take in only words
    # with only alphanumeric characters and have min. two characters.
    wordRegex = /^[a-z0-9]{2,}$/

    # Pick out only nouns and words that match our regex above.
    if tag in ["NN", "NNP", "NNPS"] and wordRegex.test word
      selected[word] ?= count: 0
      selected[word].count += 1
      selected[word].tag = tag
      selected[word].word = word

  # Reject nouns that have occured less than once
  selected = _.reject selected, (word) -> word.count <= 1

  # Sort the nouns and return!
  _.sortBy selected, (word) -> word.count


Controller = module.exports = (settings) ->
  # fetchInformationWithRead "http://yourstory.com/2016/02/uncool-non_tech-company-era/"
  # .then getKeywords

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
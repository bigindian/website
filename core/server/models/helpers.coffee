Promise       = require "bluebird"
read          = require "node-readability"
htmlToText    = require "html-to-text"
readingTime   = require "reading-time"
MetaInspector = require "node-metainspector"


module.exports =
  ###
  **fetchInformation()** Gets information about the given URL and returns a
  JSON which can be used for initializing the story.
  ###
  fetchInformation: (url, EXCERPT_LENGTH=500) -> new Promise (resolve, reject) ->
    read url, (error, article, meta) ->
      if error then return reject error

      text = htmlToText.fromString article.content,
        hideLinkHrefIfSameAsText: true
        ignoreHref: true
        ignoreImage: true

      onMetaInspectFinish = (meta={}) ->
        resolve
          title: meta.title
          excerpt: text.substr 0, text.lastIndexOf " ", EXCERPT_LENGTH
          image_url: meta.image
          meta:
            time: readingTime text


      client = new MetaInspector url
      client.on "fetch", -> onMetaInspectFinish client
      client.on "error", (error) -> reject error
      client.fetch()
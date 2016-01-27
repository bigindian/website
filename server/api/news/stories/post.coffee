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


###
**getExtension()** Returns the extension of the given filename.
###
getExtension = (filename) -> (/(?:\.([^.]+))?$/.exec filename)[1] or "jpeg"



###
**getDominantColor()** Helper function to get the dominant colour for the given
image
###
getDominantColor = (filepath) ->
  rgbToHex = (rgb) ->
    componentToHex = (c) ->
      hex = c.toString 16
      if hex.length == 1 then "0#{hex}" else hex
    "##{componentToHex rgb[0]}#{componentToHex rgb[1]}#{componentToHex rgb[2]}"

  thief = new colorThief()
  rgbToHex thief.getColor filepath


###
**fetchInformation()** Gets information about the given URL and returns a
JSON which can be used for initializing the story.
###
fetchInformation = (url, EXCERPT_LENGTH=500) -> new Promise (resolve, reject) ->
  read url, (error, article, meta) ->
    if error then return reject error

    text = htmlToText.fromString article.content,
      hideLinkHrefIfSameAsText: true
      ignoreHref: true
      ignoreImage: true

    onMetaInspectFinish = (meta={}) ->
      resolve
        excerpt: text.substr 0, text.lastIndexOf " ", EXCERPT_LENGTH
        image_url: meta.image
        words_count: text.split(" ").length


    client = new MetaInspector url
    client.on "fetch", -> onMetaInspectFinish client
    client.on "error", (error) -> reject error
    client.fetch()


IMAGE_MAXSIZE_THUMB = 400 # 400px x 400px


Controller = module.exports = (Settings, Story) ->
  validateStory = (story={}) ->
    story.url = normalizeUrl story.url
    Story.findOne url: story.url
    .then (result) ->
      if result? then throw new Error "story exists"
      story


  (request, response, next) ->
    validateStory request.body
    .then (story) -> Story.create story
    .then (story) ->
      fetchInformation story.url
      .then (info) ->
        story.excerpt = info.excerpt
        story.image_url = info.image_url
        story.words_count = info.words_count
        story.slug = slug story.title

        if not story.image_url? then return story

        extension = getExtension story.image_url
        filename = "#{story._id}.#{extension}"
        uploadPath = "#{Settings.publicDir}/uploads/#{filename}"

        new Promise (resolve) ->
          Request story.image_url
          .pipe fs.createWriteStream uploadPath
          .on "close", ->

            gm uploadPath
            .resize IMAGE_MAXSIZE_THUMB, IMAGE_MAXSIZE_THUMB
            .compress "Lossless"
            .crop IMAGE_MAXSIZE_THUMB, IMAGE_MAXSIZE_THUMB, 0, 0
            .autoOrient()
            .write uploadPath, ->

              gm uploadPath
              .size (err, size={}) ->
                story.thumbnail =
                  color: getDominantColor uploadPath
                  filename: filename
                  width: size.width
                  height: size.height

                story.save().then -> resolve story

    .then ((story) -> response.json story), (e) -> next e


Controller["@middlewares"] = ["CheckCaptcha"]
Controller["@require"] = [
  "igloo/settings"
  "models/news/story"
]
Controller["@routes"] = ["/news/stories"]
Controller["@singleton"] = true
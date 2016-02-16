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


IMAGE_MAXSIZE_THUMB = 400 # 400px x 400px


excerptify = (text="") ->
  EXCERPT_LENGTH = 500
  text.substr 0, text.lastIndexOf " ", EXCERPT_LENGTH


###
**fetchInformation()** Gets information about the given URL and returns a
JSON which can be used for initializing the story.
###
fetchInformationWithBoilerplate = (url) -> new Promise (resolve, reject) ->
  boilerpipe = new Boilerpipe
    extractor: Boilerpipe.Extractor.Article
    url: url

  textPromise = new Promise (resolve, reject) ->
    boilerpipe.getText (error, text="") ->
      if error then reject error
      resolve excerptify text

  htmlPromise = new Promise (resolve, reject) ->
    boilerpipe.getHtml (error, html) ->
      if error then reject error else return resolve html

  imagesPromise = new Promise (resolve, reject) ->
    boilerpipe.getImages (error, images=[]) ->
      if error then resolve null

      if images.length > 0
        for image in images
          if image.area > 300 * 300 then return resolve image.src

      resolve null


  Promise.props
    excerpt: textPromise
    image_url: imagesPromise
    story_html: htmlPromise
  .then (values) ->
    values.words_count = values.excerpt.split(" ").length
    resolve values
  .catch (error) -> reject error


fetchInformationWithRead = (url) -> new Promise (resolve, reject) ->
  read url, (error, article, meta) ->
    if error then return reject error

    text = htmlToText.fromString article.content,
      hideLinkHrefIfSameAsText: true
      ignoreHref: true
      ignoreImage: true

    onMetaInspectFinish = (meta={}) ->
      resolve
        excerpt: excerptify text
        story_html: article.content
        image_url: meta.image
        words_count: text.split(" ").length


    client = new MetaInspector url
    client.on "fetch", -> onMetaInspectFinish client
    client.on "error", (error) -> reject error
    client.fetch()


createThumbnail = (story, uploadDir) ->
  extension = getExtension story.image_url
  filename = "#{story._id}.#{extension}"
  uploadPath = "#{uploadDir}/#{filename}"

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

          resolve story.save()

    setTimeout (-> resolve story), 10 * 1000


Controller = module.exports = (Settings, Story, StoryExistsError) ->
  validateStory = (story={}) ->
    story.url = normalizeUrl story.url
    Story.findOne url: story.url
    .then (result) ->
      if result? then throw new StoryExistsError
      story


  (request, response, next) ->
    validateStory request.body
    .then (story) -> Story.create story
    .then (story) ->

      ### # Attempt to read the story with Boilerplate first, if that fails then
      # with Readability.
      fetchInformationWithBoilerplate story.url
      .catch (e) -> fetchInformationWithRead story.url ###
      fetchInformationWithRead story.url

      .then (info) ->
        story.excerpt = info.excerpt
        story.image_url = info.image_url
        story.words_count = info.words_count
        story.slug = slug story.title
        story.story_html = info.story_html

        if not story.image_url? then return story.save()

        createThumbnail story, "#{Settings.publicDir}/uploads"

        .finally -> story.save()

      .catch (e) ->
        # Delete the story and show an error.
        throw e

    .then ((story) -> response.json story), (e) -> next e


Controller["@middlewares"] = ["CheckCaptcha"]
Controller["@require"] = [
  "igloo/settings"
  "models/news/story"
  "libraries/errors/StoryExistsError"
]
Controller["@routes"] = ["/news/stories"]
Controller["@singleton"] = true
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


IMAGE_MIN_AREA = 300 * 300
IMAGE_MAXSIZE_THUMB = 400 # 400px x 400px
EXCERPT_LENGTH = 500


###
**getExtension()** Returns the extension of the given filename.
###
getExtension = (filename) -> (/(?:\.([^.]+))?$/.exec filename)[1] or "jpeg"



###
**getDominantColor()** Helper function to get the dominant colour for the given
image
###
getDominantColor = (filepath) ->
  rgbToHex = (rgb=[]) ->
    componentToHex = (c="") ->
      hex = c.toString 16
      if hex.length == 1 then "0#{hex}" else hex
    "##{componentToHex rgb[0]}#{componentToHex rgb[1]}#{componentToHex rgb[2]}"

  thief = new colorThief()
  rgbToHex thief.getColor filepath


excerptify = (text="") -> text.substr 0, text.lastIndexOf " ", EXCERPT_LENGTH


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
          if image.area > IMAGE_MIN_AREA then return resolve image.src

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

    if not article.title? then return reject new Error "no title"

    #! Replace title with regex from DB
    title = article.title.replace /[|].*/, ""

    text = htmlToText.fromString article.content,
      hideLinkHrefIfSameAsText: true
      ignoreHref: true
      ignoreImage: true

    onMetaInspectFinish = (meta={}) ->
      resolve
        excerpt: excerptify text
        image_url: meta.image
        story_html: article.content
        title: title
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


Controller = module.exports = (Settings, Story, StoryExistsError, CantScrapeStoryError) ->
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
        _.extendOwn story, info

        # Sometimes the title goes missing. We can't have that! So we return an
        # error.
        if not story.title? or story.title.length < 5
          throw new CantScrapeStoryError "no title"

        # If the story is coming from a news feed, then we want both an excerpt
        # and an image!
        if story.is_feed
          if not story.excerpt? or story.excerpt.length < 5
            throw new CantScrapeStoryError "no excerpt"
          if not story.image_url?
            throw new CantScrapeStoryError "no image"

        if not story.image_url? then return story.save()

        createThumbnail story, "#{Settings.publicDir}/uploads"
        .finally -> story.save()

      .catch (e) ->
        # Delete the story and show an error.
        story.remove()
        throw e

    .then ((story) -> response.json story), (e) -> next e


Controller["@middlewares"] = ["CheckCaptcha"]
Controller["@require"] = [
  "igloo/settings"
  "models/news/story"
  "libraries/errors/StoryExistsError"
  "libraries/errors/CantScrapeStoryError"
]
Controller["@routes"] = ["/news/stories"]
Controller["@singleton"] = true
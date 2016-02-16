async = require "async"
java = require "java"
path = require "path"


Library = module.exports = ->
  javaPath = path.resolve __dirname, "../../node_modules/boilerpipe/jar/"

  java.classpath.push path.resolve javaPath, "nekohtml-1.9.13.jar"
  java.classpath.push path.resolve javaPath, "xerces-2.9.1.jar"
  java.classpath.push path.resolve javaPath, "boilerpipe-core-1.2.0-xissy.jar"

  ArticleExtractor          = java.import "de.l3s.boilerpipe.extractors.ArticleExtractor"
  ArticleSentencesExtractor = java.import "de.l3s.boilerpipe.extractors.ArticleSentencesExtractor"
  BoilerpipeSAXInput        = java.import "de.l3s.boilerpipe.sax.BoilerpipeSAXInput"
  CanolaExtractor           = java.import "de.l3s.boilerpipe.extractors.CanolaExtractor"
  DefaultExtractor          = java.import "de.l3s.boilerpipe.extractors.DefaultExtractor"
  HTMLFetcher               = java.import "de.l3s.boilerpipe.sax.HTMLFetcher"
  HTMLHighlighter           = java.import "de.l3s.boilerpipe.sax.HTMLHighlighter"
  ImageExtractor            = java.import "de.l3s.boilerpipe.sax.ImageExtractor"
  InputSource               = java.import "org.xml.sax.InputSource"
  KeepEverythingExtractor   = java.import "de.l3s.boilerpipe.extractors.KeepEverythingExtractor"
  KeepEverythingWithMinKWordsExtractor = java.import "de.l3s.boilerpipe.extractors.KeepEverythingWithMinKWordsExtractor"
  LargestContentExtractor   = java.import "de.l3s.boilerpipe.extractors.LargestContentExtractor"
  NumWordsRulesExtractor    = java.import "de.l3s.boilerpipe.extractors.NumWordsRulesExtractor"
  StringReader              = java.import "java.io.StringReader"

  # http://stackoverflow.com/questions/32760782/nodemon-is-not-restarting-the-server-when-using-node-java-package
  process.once "SIGUSR2", -> process.kill process.pid, "SIGUSR2"

  class Boilerpipe
    @Extractor:
      Article: ArticleExtractor.INSTANCE
      ArticleSentences: ArticleSentencesExtractor.INSTANCE
      Canola: CanolaExtractor.INSTANCE
      Default: DefaultExtractor.INSTANCE
      KeepEverything: KeepEverythingExtractor.INSTANCE
      KeepEverythingWithMinKWords: KeepEverythingWithMinKWordsExtractor.INSTANCE
      LargestContent: LargestContentExtractor.INSTANCE
      NumWordsRules: NumWordsRulesExtractor.INSTANCE


    constructor: (params, callback) ->
      for key, value of params then @[key] = value

      @extractor ?= Boilerpipe.Extractor.Default
      @isProcessed ?= false
      @process callback if callback?


    process: (callback) ->
      if not @url and not @html
        return callback new Error "No URL or HTML provided"

      async.waterfall [
        # url or html to inputSource.
        (callback) =>
          # url?
          if @url?
            async.waterfall [
              (callback) => java.newInstance "java.net.URL", @url, callback
            , (urlObject, callback) => HTMLFetcher.fetch urlObject, callback
            , (htmlDocument, callback) =>
                @htmlDocument = htmlDocument
                htmlDocument.toInputSource callback
            ], callback

          # or html?
          else
            async.waterfall [
              (callback) => java.newInstance "java.io.StringReader", @html, callback
            , (stringReader, callback) => java.newInstance "org.xml.sax.InputSource", stringReader, callback
            ], callback
      , (inputSource, callback) => # inputSource to textDocument.
        async.waterfall [
          (callback) => java.newInstance "de.l3s.boilerpipe.sax.BoilerpipeSAXInput", inputSource, callback
        , (saxInput, callback) => saxInput.getTextDocument callback
        ], callback
      ], (error, textDocument) => # extract.
        @textDocument = textDocument
        @isProcessed = true
        @extractor.process textDocument, callback


    setUrl: (url, callback) ->
      @url = url
      @html = null
      @isProcessed = false

      if callback? then @process callback
      this


    setHtml: (html, callback) ->
      @url = null
      @html = html
      @isProcessed = false

      if callback? then @process callback
      this


    checkIsProcessed: (callback) ->
      if not @isProcessed then @process callback else callback null


    getText: (callback) ->
      @checkIsProcessed (error) =>
        return callback error if error?
        @textDocument.getContent callback


    getHtml: (callback) ->
      @checkIsProcessed (error) =>
        return callback error if error?

        async.waterfall [
          (callback) => HTMLHighlighter.newExtractingInstance callback
        , (highlighter, callback) =>
            html = @html if @html?
            html = @htmlDocument.toInputSourceSync() if @url?
            highlighter.process @textDocument, html, callback
        ], callback


    getImages: (callback) ->
      @checkIsProcessed (error) =>
        return callback error if error?

        html = @html if @html?
        html = @htmlDocument.toInputSourceSync() if @url?

        ImageExtractor.INSTANCE.process @textDocument, html, (error, imageJavaObjects) =>
          return callback error if error?
          convertImageJavaObjectsToJs imageJavaObjects, callback



  convertImageJavaObjectsToJs = (imageObjects, callback) ->
    # return callback error if error?

    imageObjects.size (error, size) ->
      return callback error if error?
      return callback null, [] if size is 0

      async.map [0...size], (i, callback) ->
        imageObjects.get i, (error, imageObject) ->
          return callback error if error?

          async.parallel
            src: (callback) -> imageObject.getSrc callback
            width: (callback) ->
              imageObject.getWidth (error, width) ->
                width = Number width if width?
                callback error, width
            height: (callback) ->
              imageObject.getHeight (error, height) ->
                height = Number height if height?
                callback error, height
            alt: (callback) -> imageObject.getAlt callback
            area: (callback) -> imageObject.getArea callback
          , callback
      , callback


Library["@singleton"] = true
Library["@require"] = ["$container"]
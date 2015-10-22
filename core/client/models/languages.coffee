Model = module.exports = ($root, Enum, $resource, BackboneModel) ->
  dictionary = {}
  resource =  $resource "/api/language/:slug", slug: "@slug"


  LanguageModel = BackboneModel.extend
    urlRoot: "/api/language/en"
    idAttribute: null

    cache: true
    localStorage: true

    translate: (text, page) -> @get "#{page}:#{text}"

    download: -> @fetch().then -> $root.$broadcast "model:language:change"


  new LanguageModel slug: "en"


Model.$inject = [
  "$rootScope"
  "@models/base/enum"
  "$resource"
  "BackboneModel"
]
exports = module.exports = (Enum, $root) ->
  class Languages extends Enum
    downloadUrl: -> "/api/language/en"
    name: "[model:language]"

    data: {}

    translate: (text, page) ->
      key = "#{page}:#{text}"
      # console.log 'translating', key
      @data[key] or ""


    onChange: -> $root.$emit "model:language:change"


  new Languages


exports.$inject = [
  "models.base.enum"
  "$rootScope"
]

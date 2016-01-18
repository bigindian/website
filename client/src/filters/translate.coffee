LanguageFilter = module.exports = (Language) ->
  (key, page) -> Language.translate(key, page) or key


LanguageFilter.$inject = ["@models/languages"]
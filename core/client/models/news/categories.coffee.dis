Model = module.exports = ($http, $resource, BackboneModel, BackboneCollection) ->
  resource = $resource "/api/news/categories"
  promise = null
  collection = null

  class Category
    @download: ->
      collection = new Category.Collection
      collection.fetch()


    @getAll: -> collection.toArray()

    @getAllbyIds: -> collection.map (item) -> item.id

    @collection: -> collection


    @Model: BackboneModel.extend {}


    @Collection: BackboneCollection.extend
      cache: true
      localStorage: true

      url: "/api/news/categories"
      model: Category.Model

  # new class Categories
  #   baseUrl: "/news/categories"
  #   tag: "model:news/categories"
  #   md5Key: "model:news_categories"

  #   ###
  #   This function returns the category (child or parent) given only it's slug.
  #   For this function to work flawlessly, it assumes that all slugs (both
  #   parent and child combined) are unique.
  #   ###
  #   findBySlug: (slug) ->
  #     for cat in @getAll()
  #       # Compare with the parent
  #       if cat.slug is slug then return cat
  #       # If parent didn't match then try with each of the child categories
  #       if cat.children? then for childcat in cat.children
  #         if childcat.slug is slug then return childcat


  #   getCounters: ->
  #     @api "/counters"
  #     .then (response) ->
  #       counters = response.data
  #       counter.stories = Number counter.stories for counter in counters
  #       counters


Model.$inject = [
  "$http"
  "$resource"
  "BackboneModel"
  "BackboneCollection"
]
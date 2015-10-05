exports = module.exports = (IoC, settings) ->
  new class ElasticSearch
    constructor: ->
      @client = global.elasticsearch
      @index = "bigindiannews"


    create: (type, id, body) ->
      @client.create index: @index, type: type, id: id, body: body


    update: (type, id, body) ->
      @client.update index: @index, type: type, id: id, body: doc: body


    search: (esDSL) ->
      esDSL.index = @index
      @client.search esDSL


exports["@require"] = [
  "$container"
  "igloo/settings"
]
exports["@singleton"] = true
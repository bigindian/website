Plugin = module.exports = (schema, options) ->
  schema.add updated_at: Date
  schema.pre "save", (next) ->
    @updated_at = new Date
    do next
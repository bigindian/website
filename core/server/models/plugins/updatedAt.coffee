Plugin = module.exports = (schema, options) ->
  schema.add updated_at: Date
  schema.pre "save", (next) ->
    this.updated_at = new Date
    next()
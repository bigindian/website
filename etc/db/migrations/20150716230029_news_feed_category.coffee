exports.up = (knex, Promise) ->
  knex.schema.createTable "news_feed_category", (table) ->
    table.increments().primary()
    table.integer("category").notNull().references("id").inTable "news_categories"
    table.integer("feed").notNull().references("id").inTable "news_feeds"
    table.unique ["category", "feed"]


exports.down = (knex, Promise) -> knex.schema.dropTable "news_feed_category"
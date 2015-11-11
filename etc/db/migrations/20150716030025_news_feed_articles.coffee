exports.up = (knex, Promise) ->
  knex.schema.createTable "news_feed_articles", (table) ->
    table.increments().primary()
    table.string("url", 250).unique().defaultTo ""
    table.string("image_url", 250).defaultTo ""
    table.string("title", 250).defaultTo ""
    table.string("excerpt", 500).defaultTo ""
    table.json("meta").defaultTo "{}"
    table.decimal("hotness", 20, 10).index().notNull().defaultTo 0.0
    table.integer("feed").notNull().references("id").inTable "news_feeds"
    table.timestamp("created_at").notNull().defaultTo knex.raw "now()"
    table.timestamp("checked_at").notNull().defaultTo knex.raw "now()"
    table.timestamp("updated_at").notNull().defaultTo knex.raw "now()"


exports.down = (knex, Promise) -> knex.schema.dropTable "news_feed_articles"
exports.up = (knex, Promise) ->
  knex.schema.createTable "news_feeds", (table) ->
    table.increments().primary()
    table.string("domain", 150).index().notNull()
    table.string("url", 250).defaultTo ""
    table.string("feed_url", 250).defaultTo ""
    table.string("color", 250).defaultTo ""
    table.json("meta").defaultTo "{}"
    table.json("last_article", 250).defaultTo "{}"
    table.timestamp("last_article_at").notNull().defaultTo knex.raw "now()"
    table.timestamp("checked_at").notNull().defaultTo knex.raw "now()"

    table.timestamp("updated_at").notNull().defaultTo knex.raw "now()"
    table.timestamp("created_at").notNull().defaultTo knex.raw "now()"


exports.down = (knex, Promise) -> knex.schema.dropTable "news_feeds"
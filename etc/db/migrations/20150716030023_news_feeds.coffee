exports.up = (knex, Promise) ->
  knex.schema.createTable "news_feeds", (table) ->
    table.increments().primary()
    table.string("domain", 150).index().notNull()
    table.string("url", 250).defaultTo ""
    table.string("slug", 250).index().notNull()
    table.string("feed_url", 250).defaultTo ""
    table.string("color", 250).defaultTo ""
    table.json("meta").defaultTo "{}"
    table.integer("hotness_mod").defaultTo 0
    table.decimal("hotness", 20, 10).index().notNull().defaultTo 0.0

    table.decimal("refresh_interval", 20).index().notNull().defaultTo 0
    table.timestamp("next_refresh_date").notNull().defaultTo knex.raw "now()"

    table.integer("articles_count").notNull().defaultTo 0
    table.timestamp("last_article_at")

    table.timestamp("checked_at").notNull().defaultTo knex.raw "now()"
    table.timestamp("updated_at").notNull().defaultTo knex.raw "now()"
    table.timestamp("created_at").notNull().defaultTo knex.raw "now()"


exports.down = (knex, Promise) -> knex.schema.dropTable "news_feeds"
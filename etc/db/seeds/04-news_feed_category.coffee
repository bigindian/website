exports.seed = (knex, Promise) ->
  knex("news_feed_category").insert category: 1, feed: 1
  .then -> knex("news_feed_category").insert category: 2, feed: 1
  .then -> knex("news_feed_category").insert category: 3, feed: 1
  # .then -> knex("news_feed_category").insert category: 2, feed: 2
  # .then -> knex("news_feed_category").insert category: 1, feed: 3
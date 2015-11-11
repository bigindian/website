exports.seed = (knex, Promise) ->
  feed =
    id: 1
    domain: "edition.cnn.com"
    url: "http://edition.cnn.com"
    # feed_url: "http://rss.cnn.com/rss/edition.rss"
    feed_url: "http://ashish.com/feed/"
    color: "#ca2026"

  knex("news_feeds").insert feed
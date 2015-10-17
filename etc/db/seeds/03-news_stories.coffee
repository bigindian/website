exports.seed = (knex, Promise) ->
  post1 =
    comments_count: 1
    created_by: 1
    description: "This is sometings cool"
    description_markdown: "<p>This is sometings cool</p>"
    domain: "github.com"
    raw_hotness: -11088.4732896
    hotness: -11088.4732896
    id: 1
    is_expired: false
    is_moderated: true
    merged_story: 1
    slug: "this-is-something-1"
    title: "This is the first link"
    created_by_uname: "admin"
    votes_count: 0
    url: "https://github.com/jcs/lobsters"
    meta:
      categories: [1, 2, 3]

  post2 =
    comments_count: 1
    created_by: 1
    created_by_uname: "admin"
    description: "This is sometings cool"
    description_markdown: "<p>This is sometings cool</p>"
    domain: "github.com"
    raw_hotness: -11088.4732896
    hotness: -11088.4732896
    id: 2
    is_expired: false
    is_moderated: true
    merged_story: 1
    slug: "this-is-something-2"
    title: "What’s Your Pain Threshold?"
    votes_count: 0
    url: "https://github.com/jcs/lobsters"
    meta:
      categories: [2]

  post3 =
    comments_count: 1
    created_by: 1
    created_by_uname: "admin"
    description: "This is sometings cool"
    description_markdown: "<p>This is sometings cool</p>"
    domain: "github.com"
    raw_hotness: -11088.4732896
    hotness: -11088.4732896
    id: 3
    is_expired: false
    is_moderated: true
    merged_story: 1
    slug: "this-is-something-3"
    title: "This is the third link"
    votes_count: 0
    url: "https://github.com/jcs/lobsters"
    meta:
      categories: [1]

  knex("news_stories").insert post1
  .then -> knex("news_stories").insert post2
  .then -> knex("news_stories").insert post3
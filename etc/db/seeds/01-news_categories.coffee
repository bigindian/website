exports.seed = (knex, Promise) ->
  uid = 0
  ins = (options) ->
    slug = options.title.toLowerCase().replace(/&/g, "").replace /[,\s]+/g, "-"
    values =
      id: ++uid
      title: options.title
      inactive: options.inactive or false
      hotness_mod: options.hotness_mod or 0
      slug: "#{slug}-#{uid}"
      meta: JSON.stringify color: options.color
    knex("news_categories").insert values


  categories = [
    { title: "advice", color: "#fffcd7" }
    { title: "apps", color: "#fffcd7" }
    { title: "audio", color: "#ddebf9" }
    { title: "big data", color: "#fffcd7" }
    { title: "biotech", color: "#fffcd7" }
    { title: "bitcoin", color: "#fffcd7" }
    { title: "book", color: "#fffcd7" }
    { title: "business", color: "#fffcd7" }
    { title: "ceo", color: "#fffcd7" }
    { title: "charity", color: "#fffcd7" }
    { title: "cloud", color: "#fffcd7" }
    { title: "college", color: "#fffcd7" }
    { title: "community", color: "#fffcd7" }
    { title: "competition", color: "#fffcd7" }
    { title: "conference", color: "#fffcd7" }
    { title: "crowdfunding", color: "#fffcd7" }
    { title: "culture", color: "#fffcd7" }
    { title: "design", color: "#fffcd7" }
    { title: "ecommerce", color: "#fffcd7" }
    { title: "education", color: "#fffcd7" }
    { title: "enterpreneur", color: "#fffcd7" }
    { title: "entertainment", color: "#fffcd7" }
    { title: "finance", color: "#fffcd7" }
    { title: "food", color: "#fffcd7" }
    { title: "funding", color: "#fffcd7" }
    { title: "funny", color: "#fffcd7" }
    { title: "giants", color: "#fffcd7" }
    { title: "government", color: "#fffcd7" }
    { title: "green", color: "#fffcd7" }
    { title: "hackathon", color: "#fffcd7" }
    { title: "hardware", color: "#fffcd7" }
    { title: "hiring", color: "#fffcd7" }
    { title: "hotels", color: "#fffcd7" }
    { title: "images", color: "#ddebf9" }
    { title: "innovative", color: "#fffcd7" }
    { title: "international", color: "#fffcd7" }
    { title: "internet", color: "#fffcd7" }
    { title: "interviews", color: "#fffcd7" }
    { title: "investing", color: "#fffcd7" }
    { title: "law", color: "#fffcd7" }
    { title: "marketing", color: "#fffcd7" }
    { title: "medical", color: "#fffcd7" }
    { title: "mobile", color: "#fffcd7" }
    { title: "music", color: "#fffcd7" }
    { title: "opinion", color: "#fffcd7" }
    { title: "politics", color: "#fffcd7" }
    { title: "privacy", color: "#fffcd7" }
    { title: "programming", color: "#fffcd7" }
    { title: "resource", color: "#fffcd7" }
    { title: "reviews", color: "#fffcd7" }
    { title: "science", color: "#fffcd7" }
    { title: "security", color: "#fffcd7" }
    { title: "shopping", color: "#fffcd7" }
    { title: "show", color: "#ddebf9" }
    { title: "social", color: "#fffcd7" }
    { title: "software", color: "#fffcd7" }
    { title: "space", color: "#fffcd7" }
    { title: "stories", color: "#ddebf9" }
    { title: "study", color: "#fffcd7" }
    { title: "success stories", color: "#fffcd7" }
    { title: "survey", color: "#fffcd7" }
    { title: "taxi", color: "#fffcd7" }
    { title: "tech & gadgets", color: "#fffcd7" }
    { title: "tips", color: "#fffcd7" }
    { title: "tools", color: "#fffcd7" }
    { title: "travel", color: "#fffcd7" }
    { title: "venture", color: "#fffcd7" }
    { title: "video", color: "#f9ddde" }
    { title: "website", color: "#fffcd7" }
    { title: "world", color: "#fffcd7" }
  ]


  Promise.all (ins cat for cat in categories)
exports.seed = (knex, Promise) ->
  uid = 0
  ins = (options) ->
    slug = options.title.toLowerCase().replace(/&/g, "").replace /[,\s]+/g, "-"
    values =
      id: ++uid
      hotness_mod: options.hotness_mod or 0
      inactive: options.inactive or false
      meta: JSON.stringify color: options.color
      slug: "#{slug}-#{uid}"
      title: options.title
    knex("news_categories").insert values


  categories = [
    { title: "advice", color: "#fffcd7" }
    { title: "apps", color: "#fffcd7" }
    { title: "audio", color: "#ddebf9" }
    { title: "big data", color: "#fffcd7" }
    { title: "bitcoin", color: "#fffcd7" }
    { title: "business", color: "#fffcd7" }
    { title: "ceo", color: "#fffcd7" }
    { title: "charity", color: "#fffcd7" }
    { title: "cloud", color: "#fffcd7" }
    { title: "college", color: "#fffcd7" }
    { title: "community", color: "#fffcd7" }
    { title: "competition", color: "#fffcd7" }
    { title: "conference", color: "#fffcd7" }
    { title: "crowdfunding", color: "#fffcd7" }
    { title: "design", color: "#fffcd7" }
    { title: "ecommerce", color: "#fffcd7" }
    { title: "education", color: "#fffcd7" }
    { title: "enterpreneur", color: "#fffcd7" }
    { title: "finance", color: "#fffcd7" }
    { title: "food", color: "#fffcd7" }
    { title: "funding", color: "#fffcd7" }
    { title: "giants", color: "#fffcd7" }
    { title: "hardware", color: "#fffcd7" }
    { title: "hiring", color: "#fffcd7" }
    { title: "images", color: "#ddebf9" }
    { title: "innovative", color: "#fffcd7" }
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
    { title: "resource", color: "#fffcd7" }
    { title: "reviews", color: "#fffcd7" }
    { title: "science", color: "#fffcd7" }
    { title: "security", color: "#fffcd7" }
    { title: "showcase", color: "#fffcd7" }
    { title: "i made this", color: "#ddebf9" }
    { title: "social", color: "#fffcd7" }
    { title: "software", color: "#fffcd7" }
    { title: "space", color: "#fffcd7" }
    { title: "success stories", color: "#fffcd7" }
    { title: "tips", color: "#fffcd7" }
    { title: "tools", color: "#fffcd7" }
    { title: "travel", color: "#fffcd7" }
    { title: "venture", color: "#fffcd7" }
    { title: "video", color: "#f9ddde" }
    { title: "world", color: "#fffcd7" }
  ]


  Promise.all do -> ins cat for cat in categories
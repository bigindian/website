Controller = module.exports = (Settings, Stories, Categories) ->

  #! This array will contain the list of urls for our sitemal in JSON format.
  urlList = [
    #! Daily urls
    {url: "/", priority: 1, freq: "daily"}
    {url: "/page/2", priority: 0.7, freq: "daily"}
    {url: "/page/3", priority: 0.7, freq: "daily"}

    #! Monthly urls
    {url: "/categories", priority: 0.3, freq: "monthly"}
  ]



  # Helper function to generate the sitemap
  generateSitemap = (urls) ->
    inner_xml = ""
    root_path = Settings.url

    generateUrlMap = (url, priority, freq) ->
      "
      <url>
        <loc>#{root_path + url}</loc>
        <changefreq>#{freq}</changefreq>
        <priority>#{priority}</priority>
      </url>
      "

    inner_xml += generateUrlMap u.url, u.priority, u.freq for u in urls
    "
    <?xml version='1.0' encoding='UTF-8'?>
    <urlset xmlns='http://www.sitemaps.org/schemas/sitemap/0.9'>
      #{inner_xml}
    </urlset>
    "


  #! Add all the category urls
  Categories.getAll().then (collections) ->
    for model in collections.toJSON()
      urlList.push url: "/category/#{model.slug}", priority: 0.5, freq: "weekly"
      urlList.push url: "/category/#{model.slug}/page/2", priority: 0.3, freq: "weekly"
      urlList.push url: "/category/#{model.slug}/recent", priority: 0.3, freq: "weekly"
      urlList.push url: "/category/#{model.slug}/recent/page/2", priority: 0.3, freq: "weekly"

  (request, response, next) ->
    response.header "Content-Type", "text/xml"
    response.send generateSitemap urlList


Controller["@require"] = [
  "igloo/settings"
  "models/news/stories"
  "models/news/categories"
]
Controller["@routes"] = ["/sitemap.xml"]
Controller["@singleton"] = true
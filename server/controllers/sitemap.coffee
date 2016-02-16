Controller = module.exports = (Settings, Stories) ->

  # This array will contain the list of urls for our sitemal in JSON format.
  urlList = [
    # Daily urls
    {url: "/", priority: 1, freq: "daily"}
    {url: "/page/2", priority: 0.7, freq: "daily"}
    {url: "/page/3", priority: 0.7, freq: "daily"}

    {url: "/comments", priority: 1, freq: "daily"}
    {url: "/comments/page/2", priority: 0.7, freq: "daily"}
    {url: "/comments/page/3", priority: 0.7, freq: "daily"}

    {url: "/recent", priority: 0.7, freq: "daily"}
    {url: "/recent/page/2", priority: 0.7, freq: "daily"}
    {url: "/recent/page/3", priority: 0.7, freq: "daily"}

    # Monthly urls
    {url: "/info/about", priority: 0.3, freq: "monthly"}
    {url: "/info/terms-privacy", priority: 0.3, freq: "monthly"}
    {url: "/info/contribute", priority: 0.3, freq: "monthly"}
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


  (request, response, next) ->
    response.header "Content-Type", "text/xml"
    response.send generateSitemap urlList


Controller["@require"] = [
  "igloo/settings"
  # "models/news/stories"
]
Controller["@routes"] = ["/sitemap.xml"]
Controller["@singleton"] = true
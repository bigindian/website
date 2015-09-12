# this is the source of the URLs on your site, in this case we use a simple
# array, actually it could come from the database
urls = [
  "about.html"
  "javascript.html"
  "css.html"
  "html5.html"
]

generateSitemap = (urls) ->
  # the root of your website - the protocol and the domain name with a trailing
  # slash
  root_path = "http://www.example.com/"

  # XML sitemap generation starts here
  priority = 0.5
  freq = "monthly"
  inner_xml = ""
  for url in urls
    inner_xml += "
    <url>
      <loc>#{root_path + url}</loc>
      <changefreq>#{freq}</changefreq>
      <priority>#{priority}</priority>
    </url>
    "
  "
  <?xml version='1.0' encoding='UTF-8'?>
  <urlset xmlns='http://www.sitemaps.org/schemas/sitemap/0.9'>
  #{inner_xml}
  </urlset>"


module.exports = Controller = (Stories) ->
  routes: ["/sitemap.xml"]

  controller: (request, response, next) ->
    response.header "Content-Type", "text/xml"
    response.send generateSitemap urls


Controller["@require"] = ["models/news/stories"]
Controller["@singleton"] = true
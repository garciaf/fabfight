###
# Blog settings
###

# Time.zone = "UTC"
activate :middleman_simple_thumbnailer

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  # blog.prefix = "blog"

  blog.permalink = "{year}/{month}/{day}/{title}.html"
  # Matcher for blog source files
  blog.sources = "articles/{year}-{month}-{day}-{title}.html"
  blog.taglink = "tag/{tag}.html"
  blog.layout = "post"
  blog.summary_separator = /READMORE/
  # blog.summary_length = 250
  blog.year_link = "{year}.html"
  blog.month_link = "{year}/{month}.html"
  blog.day_link = "{year}/{month}/{day}.html"
  # blog.default_extension = ".markdown"

  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  # Enable pagination
  blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/{num}"
end

set :casper, {
  blog: {
    url: 'http://fabfight.com',
    name: 'Fabfight',
    description: 'Talk less, fight more',
    date_format: '%d %B %Y',
    navigation: true,
    logo: nil # Optional
  },
  author: {
    name: 'Fabien',
    bio: 'Fighter and cook by night, dev by day', # Optional
    location: 'Berlin', # Optional
    website: nil, # Optional
    gravatar_email: 'fabien@fabfight.com' # Optional
  },
  navigation: {
    "Home" => "/",
    "The French Cook" => "http://the-french-cook.com",
    "Fabphoto" => "http://fabphoto.fr",
    "Fabbook" => "http://fabbook.fr"
  }
}

page '/feed.xml', layout: false
page '/sitemap.xml', layout: false

ignore '/partials/*'

ready do
  blog.tags.each do |tag, articles|
    proxy "/tag/#{tag.downcase.parameterize}/feed.xml", '/feed.xml', layout: false do
      @tagname = tag
      @articles = articles[0..5]
    end
  end

  proxy "/author/#{blog_author.name.parameterize}.html", '/author.html', ignore: false
end


# Reload the browser automatically whenever files change
activate :livereload

# Pretty URLs - http://middlemanapp.com/basics/pretty-urls/
activate :directory_indexes

# Middleman-Syntax - https://github.com/middleman/middleman-syntax
set :haml, { ugly: true }
set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

set :partials_dir, 'partials'

config = YAML.load ERB.new(File.read('parameter.yml')).result(binding)

###
# Helpers
###
activate :deploy do |deploy|
  deploy.method = :ftp
  deploy.host = config['FTP_HOST']
  deploy.user = config['FTP_USER']
  deploy.password = config['FTP_PASSWORD']
  deploy.path = config['path']
  deploy.build_before = true # default: false
end


# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css
  activate :minify_html
  # Minify Javascript on build
  activate :minify_javascript

  activate :imageoptim do |options|
    options.pngout = false
    options.svgo = false
  end
  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

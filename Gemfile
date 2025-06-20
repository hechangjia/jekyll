# frozen_string_literal: true

source "https://rubygems.org"

# Jekyll 插件
group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.12"
  gem "jekyll-seo-tag", "~> 2.8"
  #gem "jekyll-sitemap", "~> 1.4"
  gem "jekyll-redirect-from", "~> 0.16"
  gem "jemoji", "~> 0.12"
  gem "jekyll-mentions", "~> 1.6"
  gem "jekyll-archives", "~> 2.3.0"  # 添加 archives 支持
  #gem "jekyll-remote-theme"  # 添加这一行
end

gem "jekyll-theme-chirpy", "~> 7.3"

gem "html-proofer", "~> 5.0", group: :test

platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

gem "wdm", "~> 0.2.0", :platforms => [:mingw, :x64_mingw, :mswin]

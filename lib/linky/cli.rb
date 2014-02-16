require 'thor'
require 'linky/html'
require 'linky/ping'

class Linky::CLI < Thor
  include Thor::Actions

  attr_accessor :config_name

  def self.source_root
    File.expand_path('../../../templates/', __FILE__)
  end

  desc "html", "linkys screenshots"
  def html(url, reg, filename)
    html = Linky::SaveLinks.new(url, reg, filename)
    html.check_page_links
  end

  desc "parse links", "checks links"
  def status(url, reg, filename)
    status = Linky::CheckResponse.new(url, reg, filename)
    status.sort
  end

  desc "check config_name", "A full linky job"
  def check(url, reg, filename)
    html(url, reg, filename)
    status(url, reg, filename)
  end
end

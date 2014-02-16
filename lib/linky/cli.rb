require 'thor'
require 'linky/html'
require 'linky/ping'

class Linky::CLI < Thor
  include Thor::Actions

  attr_accessor :config_name

  def self.source_root
    File.expand_path('../../../templates/', __FILE__)
  end

  desc "scan", "Save some URL's"
  def scan(url, reg, filename)
    html = Linky::SaveLinks.new(url, reg, filename)
    html.check_page_links
  end

  desc "status", "checks links for errors"
  def status(url, reg, filename)
    status = Linky::CheckResponse.new(url, reg, filename)
    status.sort
  end

  desc "check", "A full linky job"
  def check(url, reg, filename)
    html(url, reg, filename)
    status(url, reg, filename)
  end
end

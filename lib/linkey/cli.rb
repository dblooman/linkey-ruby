require 'thor'
require 'linkey/html'
require 'linkey/ping'

class Linkey::CLI < Thor
  include Thor::Actions

  desc "scan", "Save some URL's"
  def scan(url, reg, filename)
    html = Linkey::SaveLinks.new(url, reg, filename)
    html.check_page_links
  end

  desc "status", "checks links for errors"
  def status(url, reg, filename)
    status = Linkey::CheckResponse.new(url, reg, filename)
    status.sort
  end

  desc "check", "A full linkey job"
  def check(url, reg, filename)
    scan(url, reg, filename)
    status(url, reg, filename)
  end
end

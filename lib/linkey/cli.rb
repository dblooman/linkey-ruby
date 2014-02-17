require 'thor'
require 'linkey/html'
require 'linkey/ping'

class Linkey::CLI < Thor
  include Thor::Actions

  desc "scan", "Save some URL's"
  def scan(url, filename)
    html = Linkey::SaveLinks.new(url, filename)
    html.check_page_links
  end

  desc "status", "checks links for errors"
  def status(url, base, reg, filename)
    status = Linkey::CheckResponse.new(url, base, reg, filename)
    status.sort
  end

  desc "check", "A full linkey job"
  def check(url, base, reg, filename)
    scan(url, filename)
    status(url, base, reg, filename)
  end
end

require 'thor'
require 'linkey/html'
require 'linkey/ping'
require 'linkey/checker'

class Linkey::CLI < Thor
  include Thor::Actions

  desc "scan", "Save some URL's"
  def scan(url, filename)
    html = Linkey::SaveLinks.new(url, filename)
    html.capture_links
  end

  desc "status", "checks links for errors"
  def status(url, base, reg, filename)
    status = Linkey::CheckResponse.new(url, base, reg, filename)
    status.check_links
  end

  desc "check URL Base_URL File", "A full linkey job"
  def check(url, base, reg, filename)
    scan(url, filename)
    status(url, base, reg, filename)
  end

  desc "status check URL", "A linkey job using predetermined URL's"
  def smoke
    smoke = Linkey::Checker.new#(path)
    smoke.test
  end
end

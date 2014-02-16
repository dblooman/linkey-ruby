require 'linky'
class Linky::SaveLinks
  attr_accessor :url, :reg, :file_name

  def initialize(url, reg, file_name)
    @url = url
    @reg = reg
    @file_name = file_name
  end

  def js_file
    File.expand_path('javascript/snap.js', File.dirname(__FILE__))
  end

  def check_page_links
    puts `phantomjs "#{js_file}" "#{url}" "#{reg}" > "#{file_name}"`
  end
end

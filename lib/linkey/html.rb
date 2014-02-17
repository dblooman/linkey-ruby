require 'linkey'

class Linkey::SaveLinks
  attr_accessor :url, :file_name

  def initialize(url, file_name)
    @url = url
    @file_name = file_name
  end

  def js_file
    File.expand_path('javascript/snap.js', File.dirname(__FILE__))
  end

  def check_page_links
    puts `phantomjs "#{js_file}" "#{url}" > "#{file_name}"`
  end
end

# require 'linky/linky'
require 'open-uri'

class Linky::CheckResponse
  attr_accessor :url, :reg, :file_name

  def initialize(url, reg, file_name)
    @url = url
    @reg = reg
    @file_name = file_name
  end

  def cut
    url.gsub("#{reg}", '')
  end

  def sort
    array = []
    links = File.read(file_name)
    array << links
    links(array)
  end

  def links(links)
    links.each do |url_links|
      scan(url_links)
    end
  end

  def scan(page_links)
    urls = page_links.scan(/^#{Regexp.quote(reg)}(?:|.+)?$/)
    status(urls)
  end

  def status(urls)
    puts "Checking..."
    urls.each do |page_path|
      begin
        gets = open(cut + page_path)
        status = gets.status.first
        puts "Status is #{status} for #{cut}#{page_path}"
      rescue OpenURI::HTTPError => ex
        puts "Status is NOT GOOD for #{cut}#{page_path}" 
      end  
    end
    puts "All Done!"
  end
end

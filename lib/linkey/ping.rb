require 'linkey'
require 'open-uri'

class Linkey::CheckResponse
  attr_accessor :url, :base, :reg, :file_name

  def initialize(url, base, reg, file_name)
    @url = url
    @base = base
    @reg = reg
    @file_name = file_name
  end

  def check_links
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
    @output = []
    puts "Checking..."
    urls.each do |page_path|
      begin
        gets = open(base + page_path)
        status = gets.status.first
        puts "Status is #{status} for #{base}#{page_path}"
      rescue OpenURI::HTTPError
        if status != 200
          puts "Status is NOT GOOD for #{base}#{page_path}"
          @output << page_path
        end
      end
    end
    output
    puts "All Done!"
  end

  def output
    exit 1 if !@output.nil?
  end  
end

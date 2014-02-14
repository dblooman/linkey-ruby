require 'linky/linky'
require 'open-uri'

class Linky::CheckResponse
  attr_reader :linky

  def initialize(config)
    @linky = Linky::Config.new(config)
  end

  def open_files
    files = Dir.glob("#{linky.directory}/*/*.md")
  end

  def check_status
    arr = []
    open_files.each do |f|
      link_file = File.read(f)
      arr << link_file
      arr.each {|l| @news = l.scan(/^\/news(?:|.+)?$/)}
      status(@news)
    end
  end

  def status(urls)
    urls.each do |url|
      begin
        gets = open(linky.base_domain + url)
        puts "Status is #{gets.status} for #{url}"
      rescue OpenURI::HTTPError => ex
        puts "Status is NOT GOOD for #{url}" 
      end  
    end
  end
end

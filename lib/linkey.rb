require "linkey/version"
require 'open-uri'
require 'yaml'

module Linkey
  autoload :CLI, 'linkey/cli'

  class CheckResponse
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
      check_for_broken
    end

    def check_for_broken
      puts "Checking"
      if @output.empty?
        puts 'URL\'s are good, All Done!'
        exit 0
      else
        puts 'Buddy, you got a broken link'
        puts @output
        exit 1
      end
    end
  end

  class SaveLinks
    attr_accessor :url, :file_name

    def initialize(url, file_name)
      @url = url
      @file_name = file_name
    end

    def js_file
      File.expand_path('linkey/javascript/snap.js', File.dirname(__FILE__))
    end

    def capture_links
      puts `phantomjs "#{js_file}" "#{url}" > "#{file_name}"`
    end
  end

  class Checker < CheckResponse

    def initialize(config)
      @smoke_urls = YAML::load(File.open("#{config}"))
    end

    def base
      @smoke_urls['base']
    end

    def self.smoke
      urls = @smoke_urls['paths']
      status(urls)
    end
  end
end

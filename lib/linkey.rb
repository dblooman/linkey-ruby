require 'linkey/version'
require 'yaml'
require 'parallel'
require 'typhoeus'

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
      Getter.status(urls, base)
    end
  end

  class Getter
    def self.status(urls, base, headers = {}, status_code = 200)
      @output = []
      puts 'Checking...'
      Parallel.each(urls, in_threads: 4) do |page_path|
        request = Typhoeus.get(base + page_path.chomp('/'), headers)
        status = request.code
        make_request(page_path, base, status, status_code)
      end
      check_for_broken
    end

    def self.make_request(page_path, base, status, status_code)
      if status != status_code
        puts "Status is NOT GOOD for #{base}#{page_path}, response is #{status}"
        @output << page_path
      else
        puts "Status is #{status} for #{base}#{page_path}"
      end
    end

    def self.check_for_broken
      puts 'Checking'
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
      @smoke_urls = YAML.load(File.open("#{config}"))
    end

    def base
      @smoke_urls['base']
    end

    def smoke
      urls = @smoke_urls['paths']
      options = @smoke_urls['headers']
      headers = Hash[*options]
      @smoke_urls['status_code'] ? status_code = @smoke_urls['status_code'] : status_code = 200
      Getter.status(urls, base, headers, status_code)
    end
  end
end

require "linkey/version"
require "yaml"
require "typhoeus"

module Linkey
  autoload :CLI, "linkey/cli"

  class CheckResponse
    attr_accessor :url, :base, :reg, :file_name

    def initialize(url, base, reg, file_name)
      @url = url
      @base = base
      @reg = reg
      @file_name = file_name
    end

    def check_links
      links_list = File.read(file_name).split(",")
      links(links_list)
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

  class SaveLinks
    attr_accessor :url, :file_name

    def initialize(url, file_name)
      @url = url
      @file_name = file_name
    end

    def js_file
      File.expand_path("linkey/javascript/snap.js", File.dirname(__FILE__))
    end

    def capture_links
      puts `phantomjs "#{js_file}" "#{url}" > "#{file_name}"`
    end
  end

  class Checker
    def initialize(config)
      @smoke_urls = YAML.load(File.open("#{config}"))
    end

    def base
      @smoke_urls["base"]
    end

    def smoke
      urls = @smoke_urls["paths"]
      options = @smoke_urls["headers"]
      headers = Hash[*options]
      @smoke_urls["status_code"] ? status_code = @smoke_urls["status_code"] : status_code = 200
      Getter.status(urls, base, { :headers => headers }, status_code)
    end
  end

  class Getter
    HYDRA = Typhoeus::Hydra.new(:max_concurrency => 100)

    def self.status(urls, base, headers = {}, status_code = 200)
      puts "Checking..."

      requests = urls.map do |page_paths|
        begin
          request = Typhoeus::Request.new(base + page_paths, :followlocation => true, :ssl_verifypeer => false, :headers => headers[:headers])
          HYDRA.queue(request)
          request
        rescue
          puts "Error with URL #{page_paths}, please check config"
        end
      end

      HYDRA.run

      requests.map do |request|
        begin
          status = request.response.code
          url = request.response.options[:effective_url]
          make_request(url, status, status_code)
        rescue
          puts "Unable to get status code"
        end
      end

      check_for_broken
    end

    def self.make_request(url, status, status_code)
      @output = []
      if status != status_code
        puts "Status is NOT GOOD for #{url}, response is #{status}"
        @output << url
      else
        puts "Status is #{status} for #{url}"
      end
    end

    def self.check_for_broken
      puts "Checking"
      if @output.empty?
        puts 'URL\'s are good, All Done!'
        exit 0
      else
        puts "Buddy, you got a broken link"
        puts @output
        exit 1
      end
    end
  end
end

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
      Getter.new(urls, base).check
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
      Getter.new(urls, base, { :headers => headers }, status_code).check
    end
  end

  class Getter
    def initialize(paths, base, headers = {}, status = 200)
      @paths   = paths
      @base    = base
      @headers = headers
      @status  = status
    end

    def check
      puts "Checking..."

      paths.each do |path|
        begin
          Typhoeus::Request.new(url(path), options).tap do |req|
            req.on_complete { |r| parse_response(r, status) }
            HYDRA.queue req
          end
        rescue
          puts "Error with URL #{path}, please check config"
        end
      end

      HYDRA.run
      check_for_broken
    end

    private

    attr_reader :base, :headers, :paths, :status

    HYDRA = Typhoeus::Hydra.new(:max_concurrency => 100)

    def check_for_broken
      puts "Checking"
      if output.empty?
        puts 'URL\'s are good, All Done!'
        exit 0
      else
        puts "Buddy, you got a bad link"
        puts output
        exit 1
      end
    end

    def make_request(url, status, status_code)
      if status != status_code
        puts "Status is NOT GOOD for #{url}, response is #{status}"
        output << url
      else
        puts "Status is #{status} for #{url}"
      end
    end

    def options
      {
        :followlocation => true,
        :ssl_verifypeer => false,
        :headers        => headers[:headers]
      }
    end

    def output
      @output ||= []
    end

    def parse_response(resp, status)
      make_request(
        resp.options[:effective_url],
        resp.code,
        status
      )
    rescue
      puts "Unable to get status code"
    end

    def url(path)
      "#{base}#{path}"
    end
  end
end

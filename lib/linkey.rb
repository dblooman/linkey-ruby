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
    attr_accessor :config

    def initialize(config)
      @config = YAML.load(File.open("#{config}"))
    end

    def base
      config["base"]
    end

    def concurrency
      config["concurrency"] ? config["concurrency"] : 100
    end

    def status_code
      config["status_code"] ? config["status_code"] : 200
    end

    def smoke
      urls = config["paths"]
      options = config["headers"]
      headers = Hash[*options]
      Getter.new(urls, base, concurrency, status_code, { :headers => headers }).check
    end
  end

  class Getter
    def initialize(paths, base, concurrency, status, headers = {})
      @paths       = paths
      @base        = base
      @headers     = headers
      @status      = status

      @hydra = Typhoeus::Hydra.new(:max_concurrency => concurrency)
    end

    def check
      puts "Checking..."

      paths.each do |path|
        begin
          Typhoeus::Request.new(url(path), options).tap do |req|
            req.on_complete { |r| parse_response(r, status) }
            hydra.queue req
          end
        rescue URI::InvalidURIError
          puts "Error with URL #{path}, please check config."
        end
      end

      hydra.run
      check_for_broken
    end

    private

    attr_reader :base, :headers, :paths, :status, :concurrency, :hydra

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

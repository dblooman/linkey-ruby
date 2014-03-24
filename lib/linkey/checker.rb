require 'linkey'
require 'open-uri'
require 'yaml'

class Linkey::Checker < Linkey::CheckResponse

  def initialize(config)
    @smoke_urls = YAML::load(File.open("#{config}"))
  end

  def base
    @smoke_urls['base']
  end

  def smoke
    urls = @smoke_urls['paths']
    status(urls)
  end
end

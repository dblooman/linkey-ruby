require 'linky/linky'

class Linky::SaveLinks
  attr_reader :linky

  def initialize(config)
    @linky = Linky::Config.new(config)
  end

  def directory
    linky.directory
  end

  def engine
    linky.engine.each { |label, browser| return browser }
  end

  def urls(path)
    linky.base_domain + path
  end

  def file_names(width, label, domain_label)
    "#{directory}/#{label}/#{width}_#{engine}_#{domain_label}.md"
  end

  def check_links
    linky.paths.each do |label, path|
      url = urls(path)
      
      linky.widths.each do |width|
        file_name = file_names(width, label, linky.domain_label)    
        linky.check_page_links engine, url, width, file_name
      end
    end
  end
end

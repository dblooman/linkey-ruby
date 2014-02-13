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

  def test
    arr = []
  	open_files.each do |f|
  	  test = File.read(f)
      arr << test
  	  links = arr.each do |l|
        news = l.scan(/^\/news(?:|.+)?$/)
        news.each do |n|
          test = n.gsub("/news/", '')
          puts test
          # final = test.reject! { |c| c.empty? }
          # puts final
          # helper = final.each {|n| n.gsub("/news/", '')}
          # puts helper
        end
      end
    end
  end

end

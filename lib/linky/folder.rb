require 'linky'

class Linky::FolderManager
  attr_reader :linky

  def initialize(config)
    @linky = Linky::Config.new(config)
  end

  def dir
    linky.directory
  end

  def clear_shots_folder
    FileUtils.rm_rf("./#{dir}")
    FileUtils.mkdir("#{dir}")
  end

  def create_folders
    linky.paths.each do |folder_label, path|
      FileUtils.mkdir("#{dir}/#{folder_label}")
    end
    puts 'Creating Folders'
  end
end

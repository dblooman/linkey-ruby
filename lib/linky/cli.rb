require 'thor'
require 'linky'
require 'linky/html'
require 'linky/folder'

class Linky::CLI < Thor
  include Thor::Actions

  attr_accessor :config_name

  def self.source_root
    File.expand_path('../../../templates/', __FILE__)
  end

  desc "setup", "creates config folder and default config"
  def setup
    template('configs/config.yaml', 'configs/config.yaml')
    template('javascript/test.js', 'javascript/test.js')
  end

  desc "reset_shots", "removes all the files in the shots folder"
  def reset_shots(config_name)
    reset = Linky::FolderManager.new(config_name)
    reset.clear_shots_folder
  end

  desc "folders", "create folders for images"
  def setup_folders(config_name)
    create = Linky::FolderManager.new(config_name)
    create.create_folders
  end

  desc "html", "linkys screenshots"
  def html(config_name)
    html = Linky::SaveLinks.new(config_name)
    html.check_links
  end

  desc "check config_name", "A full linky job"
  def check(config)
    reset_shots(config)
    setup_folders(config)
    html(config)
  end
end

require 'yaml'

class Linky::Config
  attr_accessor :config

  def initialize(config_name)
    @config = YAML::load(File.open("configs/#{config_name}.yaml"))
  end

  def directory
    @config['directory'].first
  end

  def snap_file
    @config['snap_file']
  end

  def widths
    @config['screen_widths']
  end

  def domain
    @config['domain']
  end

  def base_domain
    domain[domain_label]
  end

  def domain_label
    domain.keys[0]
  end

  def paths
    @config['paths']
  end

  def engine
    @config['browser']
  end
end

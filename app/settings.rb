require 'yaml'

class Settings
  def initialize
    @data = YAML.load_file(File.expand_path('config.yml', File.dirname(__FILE__)))
  end

  def self.services
    ['ohloh', 'github', 'twitter']
  end

  def method_missing(m, *args, &block)
    return @data[m.to_s] if @data.include? m.to_s
    super
  end
end

Settings.new

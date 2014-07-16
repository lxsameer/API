require 'yaml'

class Settings
  def initialize
    @data = YAML.load_file(File.expand_path(__FILE__, 'config.yml'))
  end

  def method_missing(m, *args, &block)
    return @data[m.to_s] if @data.include? m.to_s
    super
  end
end

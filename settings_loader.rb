require 'yaml'

class SettingsLoader
  class << self
    ##
    # assumes the following format
    #  NAME1 = value1
    #  NAME2 = value2
    def load
      file = YAML.load_file(File.dirname(__FILE__) + '/settings.yml')
      file.each do |key, value|
        ENV[key] = value
      end
    end
  end
end
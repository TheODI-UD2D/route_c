require 'yaml'
require "route_c/version"

module RouteC
  class Query
    def self.config
      YAML.load_file 'config/config.yaml' 
    end
  end
end

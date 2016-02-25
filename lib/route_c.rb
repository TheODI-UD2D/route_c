require 'yaml'
require "route_c/version"

module RouteC
  class Query
    def initialize(station, direction, datetime = nil)
      @station, @direction, @datetime = station, direction, set_datetime(datetime)
    end

    def set_datetime(datetime)
      if datetime.nil?
        hour = Time.now.hour
        minute = Time.now.min
        "2015-09-23T#{hour}:#{minute}:00"
      else
        datetime
      end
    end
    def self.config
      YAML.load_file 'config/config.yaml' 
    end
  end
end

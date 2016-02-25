require 'yaml'
require 'dotenv'
require 'open-uri'

require "route_c/version"

Dotenv.load

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

    def url
      "#{config['base_url']}#{@direction}/#{@station}/#{@datetime}.json"
    end

    def config
      @config ||= YAML.load_file 'config/config.yaml'
    end

    def json
      request = open(url, http_basic_authentication: [
        ENV['SIR_HANDEL_USERNAME'],
        ENV['SIR_HANDEL_PASSWORD']
      ])
      JSON.parse request.read
    end
  end
end

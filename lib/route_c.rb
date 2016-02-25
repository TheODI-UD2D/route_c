require 'yaml'
require 'json'
require 'dotenv'
require 'open-uri'
require 'pi_piper'

require "route_c/version"
require "route_c/cli"

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
      "#{Query.config['base_url']}#{@direction}/#{@station}/#{@datetime}.json"
    end

    def self.config
      YAML.load_file 'config/config.yaml'
    end

    def self.pins
      YAML.load_file 'config/pins.yaml'
    end

    def json
      request = open(url, http_basic_authentication: [
        ENV['SIR_HANDEL_USERNAME'],
        ENV['SIR_HANDEL_PASSWORD']
      ])
      JSON.parse request.read
    end

    def average_occupancy
      loads = json.first.last
      average = loads.values.inject{ |sum, el| sum + el }.to_f / loads.size
      average.round
    end

    def self.num_elements average, elements = Query.pins.count
      (elements * (average / 100.0)).round
    end

    def to_a
      num = Query.num_elements average_occupancy
      Array.new(Query.pins.count).each_with_index.map { |k,v| v + 1 <= num ? 1 : 0 }
    end

    def to_lights
      to_a.each_with_index do |b, i|
        if b == 1
          lights[i].on
          sleep Query.config['interval']
        end
      end
      sleep Query.config['pause']
      lights.reverse.each { |l| l.off ; sleep Query.config['interval'] }
    end

    def light_on(index)
      lights[index].on
      sleep Query.config['interval']
    end

    def light_off(index)
      lights[index].off
      sleep Query.config['interval']
    end

    def lights
      @lights ||= Query.pins.map { |p| PiPiper::Pin.new(pin: p, direction: :out) }
    end
  end
end

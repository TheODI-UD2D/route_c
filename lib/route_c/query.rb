module RouteC
  class Query
    def initialize(station, direction, datetime = nil)
      @station, @direction, @datetime, @config = station, direction, set_datetime(datetime), Config.new
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
      "#{@config.base_url}#{@direction}/#{@station}/#{@datetime}.json"
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

    def self.num_elements average, elements = Config.new.lights.count
      (elements * (average / 100.0)).round
    end

    def to_a
      num = Query.num_elements average_occupancy
      Array.new(@config.lights.count).each_with_index.map { |k,v| v + 1 <= num ? 1 : 0 }
    end

    def to_lights
      lights.turn_on
    end

    def lights
      @lights ||= Lights.new(to_a)
    end

    def self.boundify direction
      case direction
        when /^n/
          'northbound'
        when /^s/
          'southbound'
        else
          raise "Invalid direction '#{direction}'"
      end
    end

  end
end

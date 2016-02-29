module RouteC
  class Lights

    def initialize(array)
      @array = array
    end

    def turn_on
      @array.each_with_index do |b, i|
        if b == 1
          lights[i].on
          sleep Query.config['interval']
        end
      end
      sleep Query.config['pause']
      lights.reverse.each { |l| l.off ; sleep Query.config['interval'] }
    end

    def lights
      @lights ||= Lights.pins.map { |p| PiPiper::Pin.new(pin: p, direction: :out) }
    end

    def release
      lights.map { |l| l.release }
    end

    def self.pins
      YAML.load_file('config/pins.yaml')['lights']
    end

    def self.button
      YAML.load_file('config/pins.yaml')['button']
    end
  end
end

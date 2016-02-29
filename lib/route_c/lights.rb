module RouteC
  class Lights

    def initialize(array)
      @array, @config = array, Config.new
    end

    def turn_on
      @array.each_with_index do |b, i|
        if b == 1
          lights[i].on
          sleep @config.interval
        end
      end
      sleep @config.pause
      lights.reverse.each { |l| l.off ; sleep @config.interval }
    end

    def lights
      @lights ||= @config.lights.map { |p| PiPiper::Pin.new(pin: p, direction: :out) }
    end

    def release
      lights.map { |l| l.release }
    end
  end
end

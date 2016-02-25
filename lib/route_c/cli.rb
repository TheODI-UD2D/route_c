require 'thor'

module RouteC
  class CLI < Thor
    desc 'version', 'Print routec version'
    def version
      puts "routec version #{VERSION}"
    end
    map %w(-v --version) => :version

    desc 'lights', 'Show lights for station and direction'
    method_option :time,
                  type: :string,
                  default: '2015-09-23T18:00',
                  desc: 'Show lights for time (on 23rd Sept)'

    method_option :console,
                  type: :boolean,
                  default: false,
                  desc: 'Dump output to console (instead of LEDs)'

    def lights station, direction
      routec = RouteC::Query.new station, direction, options[:time]
      if options['console']
        puts routec.to_a.inspect
      else
        routec.to_lights
      end
    end
  end
end

require 'thor'
require 'pi_piper'

module RouteC
  class CLI < Thor
    desc 'version', 'Print routec version'
    def version
      puts "routec version #{VERSION}"
    end
    map %w(-v --version) => :version

    desc 'lights <STATION> <DIRECTION> [--datetime]', 'Show lights for station and direction'
    method_option :time,
                  type: :string,
                  default: '2015-09-23T18:00',
                  desc: 'Show lights for time (on 23rd Sept)'

    method_option :console,
                  type: :boolean,
                  default: false,
                  desc: 'Dump output to console (instead of LEDs)'

    def lights station, direction
      begin
        routec = RouteC::Query.new station, direction, options[:time]
      rescue RouteCException => rce
        puts rce.status
        exit 1
      end

      if options['console']
        puts routec.to_a.inspect
      else
        routec.to_lights
      end
    end

    desc 'watch', 'wait for a button'
    method_option :daemon,
                  type: :boolean,
                  default: false,
                  desc: 'Creates a file `.pid` with the current process ID'
    def watch
      if options['daemon']
        file = File.new(File.join('/', 'tmp', '.pid'), 'w+')
        file.write(Process.pid)
        file.rewind
        file.close
      end

      print 'Waiting for you to push the button... '
      PiPiper.watch pin: config.button do
        RouteC::CLI.new.watching
      end

      PiPiper.wait
    end

    no_tasks do
      def watching
        puts 'done'
        print 'Getting data... '
        routec = RouteC::Query.new config.station, config.direction
        puts 'done'

        print 'Lighting lights... '
        routec.to_lights
        puts 'done'

        print 'Releasing lights... '
        routec.lights.release
        puts 'done'

        print 'Waiting for you to push the button... '
      end

      def config
        @config ||= Config.new
      end
    end
  end
end

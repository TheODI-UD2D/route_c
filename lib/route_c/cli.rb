require 'thor'
require 'pi_piper'

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

    desc 'watch', 'wait for a button'
    def watch

      print 'Waiting for you to push the button... '
      PiPiper.watch pin: 21 do
        puts 'done'
        print 'Getting data... '
        routec = RouteC::Query.new 'euston', 'southbound', '2015-09-23T08:15'
        puts 'done'

        print 'Lighting lights... '
        routec.to_lights
        puts 'done'

        print 'Releasing lights... '
        routec.release
        puts 'done'

        print 'Waiting for you to push the button... '
      end

      PiPiper.wait
    end
  end
end

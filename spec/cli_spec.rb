module RouteC
  describe CLI do

    before(:each) do
      Timecop.freeze('2015-09-23T7:48:00')
    end

    after(:each) do
      Timecop.return
    end

    it 'outputs the version' do
      expect { subject.version }.to output(/^routec version #{VERSION}$/).to_stdout
    end

    it 'lights the lights', :vcr do
      expect(RouteC::Lights).to receive(:new).with([1, 1, 1, 1, 1, 1, 0, 0]) do
        double = instance_double(RouteC::Lights)
        expect(double).to receive(:turn_on)
        double
      end

      subject.lights('euston', 'southbound')
    end

    it 'returns an array', :vcr do
      subject.options = { 'console' => true }
      expect { subject.lights('euston', 'southbound') }.to output("[1, 1, 1, 1, 1, 1, 0, 0]\n").to_stdout
    end

    it 'allows the datetime to be specified', :vcr do
      subject.options = { time: '2015-09-17T20:00:00Z' }
      expect(RouteC::Query).to receive(:new).with('euston', 'southbound', '2015-09-17T20:00:00Z') do
        double = instance_double(RouteC::Query)
        expect(double).to receive(:to_lights)
        double
      end
      subject.lights('euston', 'southbound')
    end

    it 'barfs on bad parameters' do
      expect { subject.lights 'Llaniog', 'sb'}.to exit_with_status 1
    end

    it 'watches a for a button press', :vcr do
      expect(PiPiper).to receive(:watch)
      expect(PiPiper).to receive(:wait)

      subject.watch
    end

    it 'lights lights on button press', :vcr do
      expect(RouteC::Lights).to receive(:new).with([1, 1, 1, 1, 1, 1, 0, 0]) do
        double = instance_double(RouteC::Lights)
        expect(double).to receive(:turn_on)
        expect(double).to receive(:release)
        double
      end

      subject.send(:watching)
    end

  end
end

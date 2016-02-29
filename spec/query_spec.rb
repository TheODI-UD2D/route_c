module RouteC
  describe Query do
    let(:route_c) { described_class.new('euston', 'southbound') }
    let (:now) { DateTime.parse("2016-01-01T16:20:00") }

    before(:each) do
      Timecop.travel(now)
    end

    after(:each) do
      Timecop.return
    end

    it 'sets a default datetime' do
      expect(route_c.instance_variable_get("@datetime")).to eq("2015-09-23T16:20:00")
    end

    it 'sets a url' do
      expect(route_c.url).to eq('http://goingunderground.herokuapp.com/stations/arriving/southbound/euston/2015-09-23T16:20:00.json')
    end

    it 'gets some json', :vcr do
      json = route_c.json
      expect(json.count).to eq(10)
      expect(json.first).to eq([
        {
          "segment" => 1193,
          "number" => 0,
          "timeStamp" => "2015-09-23T16:08:39.575Z"
        },
        {
          "CAR_A" => 29.443181818181817,
          "CAR_B" => 17.266666666666666,
          "CAR_C" => 12.931506849315069,
          "CAR_D" => 13.32857142857143
        }
      ])
    end

    it 'gets the average occupancy', :vcr do
      expect(route_c.average_occupancy).to eq(18)
    end

    context 'light the elements' do
      context 'populates the correct array elements' do
        it 'has 0 elements for a 0% average' do
          expect(described_class.num_elements 0).to eq (0)
        end

        it 'has 8 elements for a 100% average' do
          expect(described_class.num_elements 100).to eq 8
        end

        it 'has 4 elements for a 50% average' do
          expect(described_class.num_elements 50).to eq 4
        end

        it 'has 6 elements for a 79% average' do
          expect(described_class.num_elements 79).to eq 6
        end

        it 'has 7 elements for a 82% average' do
          expect(described_class.num_elements 82).to eq 7
        end

        it 'has 1 element for a 18% average' do
          expect(described_class.num_elements 18).to eq 1
        end
      end

      context 'with different total elements' do
        it 'has 19 out of 32 elements for a 60%' do
          expect(described_class.num_elements 60, 32).to eq 19
        end
      end

      context 'as an array', :vcr do
        it 'returns an array for an average of 18%' do
          expect(route_c.to_a).to eq [1, 0, 0, 0, 0, 0, 0, 0]
        end

        it 'returns an array for an average of 50%' do
          allow(route_c).to receive(:average_occupancy) { 50 }
          expect(route_c.to_a).to eq [1, 1, 1, 1, 0, 0, 0, 0]
        end

        it 'returns an array for an average of 82%' do
          allow(route_c).to receive(:average_occupancy) { 82 }
          expect(route_c.to_a).to eq [1, 1, 1, 1, 1, 1, 1, 0]
        end
      end
    end

    it 'lights the lights', :vcr do
      allow_any_instance_of(Object).to receive(:sleep) { nil }

      allow(PiPiper::Pin).to receive(:new) do |args|
        double = instance_double(PiPiper::Pin)
        expect(double).to receive(:on) if args[:pin] == Config.new.lights.first
        allow(double).to receive(:off)
        double
      end

      route_c.to_lights
    end

    context 'translate nb and sb' do
      it 'translates nb' do
        expect(described_class.boundify 'nb').to eq 'northbound'
      end

      it 'translates sb' do
        expect(described_class.boundify 'sb').to eq 'southbound'
      end

      it 'translates south' do
        expect(described_class.boundify 'sb').to eq 'southbound'
      end

      it 'objects to nonsense' do
        expect { described_class.boundify 'burp' }.to raise_error "Invalid direction 'burp'"
      end
    end

  end
end

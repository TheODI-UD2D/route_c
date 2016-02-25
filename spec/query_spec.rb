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

    it 'has some config' do
      expect(described_class.config['base_url']).to eq 'http://goingunderground.herokuapp.com/stations/arriving/'
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

    context 'light the lights', :vcr do
      before(:each) do
        allow_any_instance_of(Object).to receive(:sleep) { nil }
        allow(PiPiper::Pin).to receive(:new) do
          double = instance_double(PiPiper::Pin)
          allow(double).to receive(:off)
          double
        end
      end

      it 'lights the correct lights for an average of 18%' do
        expect(route_c.lights[0]).to receive(:on)
        route_c.to_lights
      end

      it 'lights the correct lights for an average of 50%' do
        allow(route_c).to receive(:to_a) { [1,1,1,1,0,0,0,0] }
        expect(route_c.lights[0]).to receive(:on)
        expect(route_c.lights[1]).to receive(:on)
        expect(route_c.lights[2]).to receive(:on)
        expect(route_c.lights[3]).to receive(:on)

        route_c.to_lights
      end

      it 'lights the correct lights for an average of 82%' do
        allow(route_c).to receive(:to_a) { [1,1,1,1,1,1,0,0] }
        expect(route_c.lights[0]).to receive(:on)
        expect(route_c.lights[1]).to receive(:on)
        expect(route_c.lights[2]).to receive(:on)
        expect(route_c.lights[3]).to receive(:on)
        expect(route_c.lights[4]).to receive(:on)
        expect(route_c.lights[5]).to receive(:on)

        route_c.to_lights
      end
    end

    it 'turns off the lights', :vcr do
      allow_any_instance_of(Object).to receive(:sleep) { nil }

      allow(PiPiper::Pin).to receive(:new) do
        double = instance_double(PiPiper::Pin)
        allow(double).to receive(:on)
        expect(double).to receive(:off)
        double
      end

      route_c.to_lights
    end
  end
end
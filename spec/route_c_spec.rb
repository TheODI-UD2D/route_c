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
      expect(route_c.config['base_url']).to eq 'http://goingunderground.herokuapp.com/stations/arriving/'
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
  end
end

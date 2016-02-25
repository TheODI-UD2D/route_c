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
  end
end

module RouteC
  describe Query do
    it 'has some config' do
      expect(described_class.config['base_url']).to eq 'http://goingunderground.herokuapp.com/stations/arriving/'
    end
  end
end

module RouteC
  describe Config do
    let(:config) { described_class.new }

    context 'default location' do

      it 'sets base_url' do
        expect(config.base_url).to eq('http://goingunderground.herokuapp.com/stations/arriving/')
      end

      it 'sets interval' do
        expect(config.interval).to eq(0.1)
      end

      it 'sets pause' do
        expect(config.pause).to eq(1)
      end

      it 'sets lights' do
        expect(config.lights).to eq([15, 18, 23, 24, 25, 8, 7, 12])
      end

      it 'sets button' do
        expect(config.button).to eq(21)
      end

    end

  end
end

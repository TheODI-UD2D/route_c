module RouteC
  describe Config do

    context 'default location' do

      let(:config) { described_class.new }

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

    context 'user specified config' do

      before(:each) do
        @home = ENV['HOME']
        ENV['HOME'] = File.join(File.dirname(__FILE__), 'fixtures', 'config')
        @config = described_class.new
      end

      after(:each) do
        ENV['HOME'] = @home
      end

      it 'sets base_url' do
        expect(@config.base_url).to eq('http://example.com/stations/arriving/')
      end

      it 'sets interval' do
        expect(@config.interval).to eq(0.2)
      end

      it 'sets pause' do
        expect(@config.pause).to eq(1)
      end

      it 'sets lights' do
        expect(@config.lights).to eq([1, 2, 3, 4, 5, 6, 7, 8])
      end

      it 'sets button' do
        expect(@config.button).to eq(10)
      end

    end

  end
end

module RouteC
  describe Lights do

    context 'light the lights' do
      before(:each) do
        allow_any_instance_of(Object).to receive(:sleep) { nil }

        allow(PiPiper::Pin).to receive(:new) do
          double = instance_double(PiPiper::Pin)
          allow(double).to receive(:off)
          double
        end
      end

      (1..8).each do |i|
        arr = Array.new(Config.new.lights.count).each_with_index.map { |k,v| v + 1 <= i ? 1 : 0 }

        it "lights #{i} lights with an array like #{arr}" do
          lights = described_class.new(arr)
          i.times { |i| expect(lights.lights[i]).to receive(:on) }
          lights.turn_on
        end
      end
    end

    it 'turns off the lights' do
      allow_any_instance_of(Object).to receive(:sleep) { nil }

      allow(PiPiper::Pin).to receive(:new) do
        double = instance_double(PiPiper::Pin)
        allow(double).to receive(:on)
        expect(double).to receive(:off)
        double
      end

      described_class.new([1,1,1,0,0,0,0]).turn_on
    end

  end
end

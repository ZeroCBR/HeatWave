describe Puller::Location::Looper do
  describe '#puller' do
    let(:old_puller) { 'old puller' }
    let(:new_puller) { 'new puller' }

    context 'after initialisation' do
      subject { Puller::Location::Looper.new(old_puller) }

      it { is_expected.to have_attributes(puller: old_puller) }

      it 'should be resetable' do
        expect { subject.puller = new_puller }.to \
          change(subject, :puller).to new_puller
      end
    end
  end

  describe '#dump' do
    subject { Puller::Location::Looper.new(puller).dump(data) }
    def source_for(location_id)
      URI(Puller::Location::Looper::SOURCE % location_id)
    end

    context 'with a stubbed puller' do
      let(:puller) { double('Puller') }
      let(:good_ids) { Set['123456', '999999', '567890'] }

      before(:example) do
        data.each_key do |l_id|
          if good_ids.include? l_id
            expect(puller).to \
              receive(:pull_from).with(source_for(l_id))
                                 .once { double('Location') }
          elsif !l_id.include? ' '
            expect(puller).to \
              receive(:pull_from).with(source_for(l_id)).once
                                 .and_raise(Net::HTTPBadResponse)
          end
        end
      end

      context 'with no locations in the weather data' do
        let(:data) { {} }

        it 'should pull no data' do
          is_expected.to eq 0
        end
      end

      context 'with only a bad location in the weather data' do
        let(:data) { { 'bad_id' => [] } }

        it 'should report zero successful pulls' do
          is_expected.to eq 0
        end
      end

      context 'with only a good location in the weather data' do
        let(:data) { { '123456' => [] } }

        it 'should report one successful pull' do
          is_expected.to eq 1
        end
      end

      context 'with many locations in the weather data' do
        let(:data) do
          data = Hash[good_ids.map { |id| [id, nil] }]
          data['bad_id'] = nil
          data['bad_id_2'] = nil

          data
        end

        it 'should return the number of locations successfully pulled' do
          is_expected.to eq good_ids.size
        end
      end
    end

    context 'with a real internal pipeline', speed: 'slow' do
      Puller::Database.initialise

      let(:pipeline) do
        { getter: Puller::Location::Getter,
          processor: Puller::Location::Processor,
          marshaler: Puller::Location::ModelMarshaler }
      end

      let(:puller) { Puller::Simple.new(pipeline) }

      before(:example) do
        pipeline[:marshaler].location_model = Location
      end

      before(:context) do
        Location.all.each { |l| l.destroy }
      end

      context 'with fake weather data' do
        let(:data) do
          { WOOP_WOOP[:id] => nil,
            MORTLAKE[:id] => nil,
            AIREYS[:id] => nil }
        end

        it 'should successfully pull each real location' do
          is_expected.to eq 2
          expect(Location.count).to eq 2
        end
      end

      context 'with real weather data' do
        MINIMUM_PULLED = 50 # Arbitrary

        let(:data) do
          Puller::Processor::data_in(Puller::Getter.get(Puller::DEFAULT_SOURCE))
        end

        it 'should successfully pull each real location' do
          is_expected.to eq Location.count
          is_expected.to be > MINIMUM_PULLED
        end
      end

      context 'within a real pipeline' do
        MINIMUM_PULLED = 50 # Arbitrary

        subject { Puller.pull_from(Puller::DEFAULT_SOURCE, weather_pipeline) }

        let(:weather_pipeline) do
          { getter: Puller::Getter,
            processor: Puller::Processor,
            marshaler: location_looper }
        end

        let(:location_looper) do
          Puller::Location::Looper.new(location_puller)
        end

        let(:location_puller) do
          Puller::Simple.new(pipeline)
        end

        it 'should pull lots of locations' do
          is_expected.to eq Location.count
          is_expected.to be > MINIMUM_PULLED
        end
      end
    end
  end
end

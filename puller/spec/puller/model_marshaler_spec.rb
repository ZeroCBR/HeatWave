require 'spec_helper'

describe Puller::ModelMarshaler do
  describe '@@weather_model' do
    subject { Puller::ModelMarshaler.weather_model }

    it 'is expected to be accessible' do
      Puller::ModelMarshaler.weather_model = 1
      is_expected.to eq(1)
    end

    it 'is expected to be accessible again' do
      Puller::ModelMarshaler.weather_model = 'model'
      is_expected.to eq('model')
    end
  end

  describe '@@location_model' do
    subject { Puller::ModelMarshaler.location_model }

    it 'is expected to be accessible' do
      Puller::ModelMarshaler.location_model = 1
      is_expected.to eq(1)
    end

    it 'is expected to be accessible again' do
      Puller::ModelMarshaler.location_model = 'model'
      is_expected.to eq('model')
    end
  end

  describe '.dump' do
    before(:context) do
      @aireys = '090180'
      @mortlake = '090176'
      @unknown_id = '387100'

      @date1 = Date.today
      @date2 = Date.today + 1

      @high_temp1 = 15
      @high_temp2 = 30
    end

    # Note: we check that the **correct** records are
    # added using before(:example) expectations, to make
    # the actual tests DRYer.
    context 'with a stubbed models' do
      let(:weather_model) { double('Weather') }

      let(:location_model) { double('Location') }
      let(:aireys) { double('Location') }
      let(:mortlake) { double('Location') }

      before(:example) do
        Puller::ModelMarshaler.weather_model = weather_model
        Puller::ModelMarshaler.location_model = location_model

        allow(location_model).to receive(:find_by_id).with(@aireys.to_i) do
          aireys
        end
        allow(location_model).to receive(:find_by_id).with(@mortlake.to_i) do
          mortlake
        end
        allow(location_model).to receive(:find_by_id).with(@unknown_id.to_i) do
          nil
        end

        data.keys.select { |l_id| l_id != @unknown_id }.each do |location_id|
          location = location_model.find_by_id(location_id.to_i)

          # Make sure we test both the create and update case.
          data[location_id].each_pair do |date, high_temp|
            allow(weather_model).to receive(:find_and_update_or_create_by)
              .with({ location: location, date: date }, high_temp: high_temp)
              .once
          end
        end
      end

      context 'with empty data' do
        let(:data) { {} }

        it 'is expected to do nothing' do
          expect(Puller::ModelMarshaler.dump(data)).to be(0)
        end
      end

      context 'with one known location' do
        context 'with no weather events' do
          let(:data) { { @aireys => {} } }

          it 'is expected to do nothing' do
            expect(Puller::ModelMarshaler.dump(data)).to be(0)
          end
        end

        context 'with one weather event' do
          let(:data) { { @aireys => { @date1 => @high_temp1 } } }

          it 'is expected to create the new Weather record' do
            expect(Puller::ModelMarshaler.dump(data)).to be(1)
          end
        end

        context 'with many weather events' do
          let(:data) do
            { @aireys => { @date1 => @high_temp1, @date2 => @high_temp2 } }
          end

          it 'is expected to create the new Weather record for each event' do
            expect(Puller::ModelMarshaler.dump(data)).to be(2)
          end
        end
      end

      context 'with one unknown location' do
        context 'with no weather events' do
          let(:data) { { @unknown_id => {} } }
          it 'is expected to do nothing' do
            expect(Puller::ModelMarshaler.dump(data)).to be(0)
          end
        end

        context 'with one weather event' do
          let(:data) { { @unknown_id => { @date1 => @high_temp1 } } }
          it 'is expected to do nothing' do
            expect(Puller::ModelMarshaler.dump(data)).to be(0)
          end
        end

        context 'with many weather events' do
          let(:data) do
            { @unknown_id => { @date1 => @high_temp1, @date2 => @high_temp2 } }
          end

          it 'is expected to do nothing' do
            expect(Puller::ModelMarshaler.dump(data)).to eq(0)
          end
        end
      end

      context 'with many locations' do
        context 'with one weather event each' do
          let(:data) do
            { @aireys => { @date1 => @high_temp1 },
              @mortlake => { @date2 => @high_temp2 },
              @unknown_id => { @date1 => @high_temp2 } }
          end

          it 'is expected to create the new Weather record for each event '\
             'with a known location' do
            expect(Puller::ModelMarshaler.dump(data)).to eq(2)
          end
        end
        context 'with many weather events each' do
          let(:data) do
            { @aireys => { @date1 => @high_temp1, @date2 => @high_temp2 },
              @mortlake => { @date1 => @high_temp1, @date2 => @high_temp2 },
              @unknown_id => { @date1 => @high_temp2, @date2 => @high_temp1 } }
          end

          it 'is expected to create the new Weather record for each event '\
             'with a known location' do
            expect(Puller::ModelMarshaler.dump(data)).to eq(4)
          end
        end
      end
    end

    context 'with real models', speed: 'slow' do
      Puller::Database.initialise

      before(:context) do
        Puller::ModelMarshaler.weather_model = Weather
        Puller::ModelMarshaler.location_model = Location

        unless Location.exists?(@aireys)
          Location.create(id: @aireys, name: 'Aireys Inlet', jan_mean: 22.8,
                          feb_mean: 23.0, mar_mean: 21.0, apr_mean: 19.0,
                          may_mean: 16.3, jun_mean: 13.9, jul_mean: 13.4,
                          aug_mean: 14.4, sep_mean: 16.2, oct_mean: 18.0,
                          nov_mean: 19.6, dec_mean: 21.1)
        end

        unless Location.exists?(@mortlake)
          Location.create(id: @mortlake, name: 'Mortlake', jan_mean: 25.9,
                          feb_mean: 26.4, mar_mean: 23.8, apr_mean: 19.9,
                          may_mean: 16.2, jun_mean: 13.5, jul_mean: 12.9,
                          aug_mean: 13.9, sep_mean: 15.8, oct_mean: 17.9,
                          nov_mean: 20.8, dec_mean: 23.2)
        end
      end

      context 'with one known location' do
        context 'with no weather events' do
          let(:data) { { @aireys => {} } }

          it 'is expected to do nothing' do
            expect(Puller::ModelMarshaler.dump(data)).to be(0)

            expect(Weather.count(location_id: @aireys, date: @date1)).to eq(0)
          end
        end

        context 'with one weather event' do
          let(:data) { { @aireys => { @date1 => @high_temp1 } } }

          it 'is expected to create a new record' do
            expect(Puller::ModelMarshaler.dump(data)).to be(1)

            result = Weather.where(location_id: @aireys, date: @date1)

            expect(result).not_to be_empty
          end

          it 'is expected to define the record correctly' do
            expect(Puller::ModelMarshaler.dump(data)).to be(1)

            result = Weather.where(location_id: @aireys, date: @date1)

            expect(result.last.high_temp).to eq(@high_temp1)
          end
        end

        context 'with a different weather event' do
          let(:data) { { @aireys => { @date1 => @high_temp1 } } }
          let(:data2) { { @aireys => { @date1 => @high_temp2 } } }

          it 'is expected to replace the old record' do
            expect(Puller::ModelMarshaler.dump(data)).to be(1)
            expect(Puller::ModelMarshaler.dump(data2)).to be(1)

            result = Weather.where(location_id: @aireys, date: @date1)

            expect(result.count).to eq(1)
            expect(result[0].high_temp).to eq(@high_temp2)
          end
        end
      end

      context 'with one unknown location' do
        context 'with no weather events' do
          let(:data) { { @unknown_id => {} } }

          it 'is expected to do nothing' do
            # Should add no records:
            expect(Puller::ModelMarshaler.dump(data)).to be(0)
            expect(Weather.where(location_id: @unknown_id)).to be_empty
          end
        end
      end

      context 'with many locations' do
        context 'with many weather events each' do
          let(:data) do
            { @aireys => { @date1 => @high_temp1, @date2 => @high_temp2 },
              @mortlake => { @date1 => @high_temp2, @date2 => @high_temp1 },
              @unknown_id => { @date1 => @high_temp2, @date2 => @high_temp1 } }
          end

          it 'is expected to set the Weather record for each event '\
             'with a known location' do
            # Should add four records:
            expect(Puller::ModelMarshaler.dump(data)).to be(4)

            result = Weather.where(location_id: @aireys, date: @date1)
            expect(result.first.high_temp).to eq(@high_temp1)

            result = Weather.where(location_id: @aireys, date: @date2)
            expect(result.first.high_temp).to eq(@high_temp2)

            result = Weather.where(location_id: @mortlake, date: @date1)
            expect(result.first.high_temp).to eq(@high_temp2)

            result = Weather.where(location_id: @mortlake, date: @date2)
            expect(result.first.high_temp).to eq(@high_temp1)

            result = Weather.where(location_id: @unknown_id)
            expect(result).to be_empty
          end
        end
      end
    end
  end
end

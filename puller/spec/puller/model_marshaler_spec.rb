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
    let(:location_id1) { '012345' }
    let(:location_id2) { '009870' }
    let(:unknown_id) { '387100' }

    let(:date1) { Date.today }
    let(:date2) { Date.today + 1 }

    let(:high_temp1) { 15 }
    let(:high_temp2) { 30 }

    context 'with a stubbed model' do
      let(:weather_model) { double('Weather') }

      let(:location_model) { double('Location') }
      let(:location1) { double('Location') }
      let(:location2) { double('Location') }

      before(:example) do
        Puller::ModelMarshaler.weather_model = weather_model
        Puller::ModelMarshaler.location_model = location_model

        allow(location_model).to receive(:find).with(location_id1) do
          location1
        end
        allow(location_model).to receive(:find).with(location_id2) do
          location2
        end
        allow(location_model).to receive(:find).with(unknown_id) do
          nil
        end

        data.keys.select { |l_id| l_id != unknown_id }.each do |location_id|
          location = location_model.find(location_id)

          data[location_id].each_pair do |date, high_temp|
            expect(weather_model).to receive(:create) \
              .with(location: location, date: date, high_temp: high_temp) \
              .once
          end
        end
      end

      context 'with empty data' do
        let(:data) { {} }

        it 'is expected to do nothing' do
          Puller::ModelMarshaler.dump(data)
        end
      end

      context 'with one known location' do
        context 'with no weather events' do
          let(:data) { { location_id1 => {} } }

          it 'is expected to do nothing' do
            Puller::ModelMarshaler.dump(data)
          end
        end

        context 'with one weather event' do
          let(:data) { { location_id1 => { date1 => high_temp1 } } }

          it 'is expected to create the new Weather record' do
            Puller::ModelMarshaler.dump(data)
          end
        end

        context 'with many weather events' do
          let(:data) do
            { location_id1 => { date1 => high_temp1, date2 => high_temp2 } }
          end

          it 'is expected to create the new Weather record for each event' do
            Puller::ModelMarshaler.dump(data)
          end
        end
      end

      context 'with one unknown location' do
        context 'with no weather events' do
          let(:data) { { unknown_id => {} } }
          it 'is expected to do nothing' do
            Puller::ModelMarshaler.dump(data)
          end
        end

        context 'with one weather event' do
          let(:data) { { unknown_id => { date1 => high_temp1 } } }
          it 'is expected to do nothing' do
            Puller::ModelMarshaler.dump(data)
          end
        end

        context 'with many weather events' do
          let(:data) do
            { unknown_id => { date1 => high_temp1, date2 => high_temp2 } }
          end
          it 'is expected to do nothing' do
            Puller::ModelMarshaler.dump(data)
          end
        end
      end

      context 'with many locations' do
        context 'with one weather event each' do
          let(:data) do
            { location_id1 => { date1 => high_temp1 },
              location_id2 => { date2 => high_temp2 },
              unknown_id => { date1 => high_temp2 } }
          end

          it 'is expected to create the new Weather record for each event '\
             'with a known location' do
            Puller::ModelMarshaler.dump(data)
          end
        end
        context 'with many weather events each' do
          let(:data) do
            { location_id1 => { date1 => high_temp1, date2 => high_temp2 },
              location_id2 => { date1 => high_temp1, date2 => high_temp2 },
              unknown_id => { date1 => high_temp2, date2 => high_temp1 } }
          end

          it 'is expected to create the new Weather record for each event '\
             'with a known location' do
            Puller::ModelMarshaler.dump(data)
          end
        end
      end
    end
  end
end

require 'spec_helper'
require 'puller/location/spec_helper'

describe Puller::Location::ModelMarshaler do
  describe '@location_model' do
    it 'is expected to be accessible' do
      Puller::Location::ModelMarshaler.location_model = 1
      expect(Puller::Location::ModelMarshaler.location_model).to eq(1)
    end

    it 'is expected to be accessible again' do
      Puller::Location::ModelMarshaler.location_model = 'model'
      expect(Puller::Location::ModelMarshaler.location_model).to eq('model')
    end
  end

  describe '.dump' do
    # Note: we check that the **correct** records are
    # added using before(:example) expectations, to make
    # the actual tests DRYer.
    context 'with a stubbed models' do
      let(:location_model) { double('Location') }
      let(:aireys) { double('Location') }
      let(:woop_woop) { double('Location') }

      before(:example) do
        Puller::Location::ModelMarshaler.location_model = location_model

        # Make sure we test both the create and update case.
        case location
        when AIREYS
          allow(location_model).to receive(:update_or_create)
            .with(location).once { 1 }
        when WOOP_WOOP
          allow(location_model).to receive(:update_or_create)
            .with(location).once { 'two' }
        else
          fail 'incomplete branch coverage'
        end
      end

      context 'with a known location' do
        let(:location) { AIREYS }
        it "is expected to update the location returning the model's result" do
          expect(Puller::Location::ModelMarshaler.dump(location)).to eq(1)
        end
      end

      context 'with an unknown location' do
        let(:location) { WOOP_WOOP }
        it "is expected to update the location returning the model's result" do
          expect(Puller::Location::ModelMarshaler.dump(location)).to eq('two')
        end
      end
    end

    context 'with real models', speed: 'slow' do
      Puller::Database.initialise
      subject { Puller::Location::ModelMarshaler.dump(location) }

      before(:context) do
        Puller::Location::ModelMarshaler.location_model = Location

        Location.create(AIREYS) unless Location.exists?(AIREYS)
        Location.destroy(WOOP_WOOP[:id]) if Location.exists?(WOOP_WOOP[:id])
      end

      after(:example) do
        Location.destroy(WOOP_WOOP[:id]) if Location.exists?(WOOP_WOOP[:id])
      end

      context 'with a known location' do
        let(:location) { AIREYS }
        it 'is expected to update and return the Location' do
          is_expected.to be_a Location
          expect(Location.exists?(AIREYS[:id])).to be true
        end
      end

      context 'with an unknown location' do
        let(:location) { WOOP_WOOP }
        it 'is expected to create and return the Location' do
          is_expected.to be_a Location
          expect(Location.exists?(WOOP_WOOP[:id])).to be true
        end
      end
    end
  end
end

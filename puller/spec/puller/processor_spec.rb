require 'spec_helper'

describe Puller::Processor do
  before(:context) do
    @header = Puller::Processor::HEADER

    @aireys = \
      '090180#Aireys Inlet#VIC#20150829#20150829#161521###7#12#5#13#5#15#8#14' \
      '#9#14#8#13#6#12#Possible shower.#Possible morning shower.#Cloudy.' \
      '#Partly cloudy.#Rain at times.#Possible shower.#Possible shower.' \
      '#Possible rain.#'

    @albury = \
      '072146#Albury-Wodonga#VIC#20150829#20150829#161521#2#16#1#16#1#15#4#' \
      '16#7#16#5#16#3#15###Partly cloudy.#Early fog and frost.#' \
      'Morning frost. Mostly sunny.#Cloudy.#Rain increasing.#Shower or two.#' \
      'Partly cloudy.#Partly cloudy.#'

    @edenhope = \
      '079099#Edenhope#VIC#20150829#20150829#161521###3#14#2#15#6#' \
      '17#8#14#7#15#5#14#2#13#Cloudy.#Partly cloudy.#Light early frost.#' \
      'Shower or two.#Rain.#Possible shower.#Partly cloudy.#Becoming cloudy.#'
  end

  describe '.data_in' do
    subject { Puller::Processor.data_in(lines) }

    context 'with no lines' do
      let(:lines) { [] }

      it 'is expected to fail' do
        expect { Puller::Processor.data_in(lines) }.to \
          raise_error(Puller::Processor::FormatError)
      end
    end

    context 'with just the header line' do
      let(:lines) { [@header] }

      it 'is expected to return an empty dataset' do
        is_expected.to eq({})
      end
    end

    context 'with the header line and one data line' do
      let(:lines) { [@header, @aireys] }

      it 'is expected to return a single element hash by id' do
        is_expected.to eq(
          '090180' => [12, 13, 15, 14, 14, 13, 12]
        )
      end
    end

    context 'with no header line but a data line' do
      let(:lines) { [@aireys] }

      it 'is expected to raise an error' do
        expect { Puller::Processor.data_in(lines) }.to \
          raise_error(Puller::Processor::FormatError)
      end
    end

    context 'with many data lines' do
      let(:lines) { [@header, @albury, @edenhope, @aireys] }

      it 'is expected to return a many element hash by id' do
        is_expected.to eq(
          '072146' => [16, 16, 15, 16, 16, 16, 15], # Albury
          '090180' => [12, 13, 15, 14, 14, 13, 12], # Aireys
          '079099' => [14, 15, 17, 14, 15, 14, 13] # Edenhope
        )
      end
    end
  end

  describe '.data_by_name' do
    subject { Puller::Processor.data_by_name(lines) }

    context 'with no lines' do
      let(:lines) { [] }

      it 'is expected to fail' do
        expect { Puller::Processor.data_in(lines) }.to \
          raise_error(Puller::Processor::FormatError)
      end
    end

    context 'with just the header line' do
      let(:lines) { [@header] }

      it 'is expected to return an empty dataset' do
        is_expected.to eq({})
      end
    end

    context 'with the header line and one data line' do
      let(:lines) { [@header, @aireys] }

      it 'is expected to return a single element hash by id' do
        is_expected.to eq(
          'Aireys Inlet' => [12, 13, 15, 14, 14, 13, 12]
        )
      end
    end

    context 'with no header line but a data line' do
      let(:lines) { [@aireys] }

      it 'is expected to raise an error' do
        expect { Puller::Processor.data_in(lines) }.to \
          raise_error(Puller::Processor::FormatError)
      end
    end

    context 'with many data lines' do
      let(:lines) { [@header, @albury, @edenhope, @aireys] }

      it 'is expected to return a many element hash by name' do
        is_expected.to eq(
          'Albury-Wodonga' => [16, 16, 15, 16, 16, 16, 15], # Albury
          'Aireys Inlet' => [12, 13, 15, 14, 14, 13, 12], # Aireys
          'Edenhope' => [14, 15, 17, 14, 15, 14, 13] # Edenhope
        )
      end
    end
  end

  describe '::ByName' do
    describe '.data_in' do
      subject { Puller::Processor::ByName.data_in(lines) }

      context 'with no lines' do
        let(:lines) { [] }

        it 'is expected to fail' do
          expect { Puller::Processor.data_in(lines) }.to \
            raise_error(Puller::Processor::FormatError)
        end
      end

      context 'with just the header line' do
        let(:lines) { [@header] }

        it 'is expected to return an empty dataset' do
          is_expected.to eq({})
        end
      end

      context 'with the header line and one data line' do
        let(:lines) { [@header, @aireys] }

        it 'is expected to return a single element hash by name' do
          is_expected.to eq(
            'Aireys Inlet' => [12, 13, 15, 14, 14, 13, 12]
          )
        end
      end

      context 'with no header line but a data line' do
        let(:lines) { [@aireys] }

        it 'is expected to raise an error' do
          expect { Puller::Processor.data_in(lines) }.to \
            raise_error(Puller::Processor::FormatError)
        end
      end

      context 'with many data lines' do
        let(:lines) { [@header, @albury, @edenhope, @aireys] }

        it 'is expected to return a many element hash by name' do
          is_expected.to eq(
            'Albury-Wodonga' => [16, 16, 15, 16, 16, 16, 15], # Albury
            'Aireys Inlet' => [12, 13, 15, 14, 14, 13, 12], # Aireys
            'Edenhope' => [14, 15, 17, 14, 15, 14, 13] # Edenhope
          )
        end
      end
    end
  end
end

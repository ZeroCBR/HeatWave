require 'spec_helper'

describe Puller::Processor do
  before(:context) do
    @header = Puller::Processor::HEADER

    @aireys = \
      '090180#Aireys Inlet#VIC#20150829#20150829#161521###7#12#5#13#5#15#8#14' \
      '#9#14#8#13#6#12#Possible shower.#Possible morning shower.#Cloudy.' \
      '#Partly cloudy.#Rain at times.#Possible shower.#Possible shower.' \
      '#Possible rain.#'

    @aireys_id = '090180'
    @aireys_want = { Date.today + 1 => 12.0,
                     Date.today + 2 => 13.0,
                     Date.today + 3 => 15.0,
                     Date.today + 4 => 14.0,
                     Date.today + 5 => 14.0,
                     Date.today + 6 => 13.0,
                     Date.today + 7 => 12.0 }

    @albury = \
      '072146#Albury-Wodonga#VIC#20150829#20150829#161521#2#16#1#16#1#15#4#' \
      '16#7#16#5#16#3#15###Partly cloudy.#Early fog and frost.#' \
      'Morning frost. Mostly sunny.#Cloudy.#Rain increasing.#Shower or two.#' \
      'Partly cloudy.#Partly cloudy.#'

    @albury_id = '072146'
    @albury_want = { Date.today     => 16.0,
                     Date.today + 1 => 16.0,
                     Date.today + 2 => 15.0,
                     Date.today + 3 => 16.0,
                     Date.today + 4 => 16.0,
                     Date.today + 5 => 16.0,
                     Date.today + 6 => 15.0 }

    @edenhope = \
      '079099#Edenhope#VIC#20150829#20150829#161521###3#14#2#15#6#' \
      '17#8#14#7#15#5#14#2#13#Cloudy.#Partly cloudy.#Light early frost.#' \
      'Shower or two.#Rain.#Possible shower.#Partly cloudy.#Becoming cloudy.#'

    @edenhope_id = '079099'
    @edenhope_want = { Date.today + 1 => 14.0,
                       Date.today + 2 => 15.0,
                       Date.today + 3 => 17.0,
                       Date.today + 4 => 14.0,
                       Date.today + 5 => 15.0,
                       Date.today + 6 => 14.0,
                       Date.today + 7 => 13.0 }
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
        is_expected.to eq(@aireys_id => @aireys_want)
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
          @albury_id => @albury_want,
          @aireys_id => @aireys_want,
          @edenhope_id => @edenhope_want
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
        is_expected.to eq('Aireys Inlet' => @aireys_want)
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
          'Albury-Wodonga' => @albury_want, # Albury
          'Aireys Inlet' => @aireys_want,
          'Edenhope' => @edenhope_want
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
          is_expected.to eq('Aireys Inlet' => @aireys_want)
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
            'Albury-Wodonga' => @albury_want,
            'Aireys Inlet' => @aireys_want,
            'Edenhope' => @edenhope_want
          )
        end
      end
    end
  end
end

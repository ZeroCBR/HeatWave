require 'spec_helper'

describe Puller::Location::Processor do
  before(:context) do
    AIREYS = { id: '090180',
               name: 'AIREYS INLET',
               jan_mean: 22.8,
               feb_mean: 23.0,
               mar_mean: 21.6,
               apr_mean: 19.0,
               may_mean: 16.3,
               jun_mean: 13.9,
               jul_mean: 13.4,
               aug_mean: 14.4,
               sep_mean: 16.2,
               oct_mean: 18.0,
               nov_mean: 19.6,
               dec_mean: 21.1 }

    MONTH_LIST = \
      '"Statistic Element","January","February","March","April","May","June",'\
      '"July","August","September","October","November","December","Annual",'\
      '"Number of Years","Start Year","End Year"'

    DEW_LINE = \
      '"Mean 9am dew point temperature (Degrees C) for years 1991 to 2010 ",'\
      '12.3,12.8,11.6,10.0,8.9,7.2,6.3,6.3,7.2,8.0,9.7,10.7,9.3,19,1991,2010'

    WOOP_WOOP = { id: '999999',
                  name: 'WOOP WOOP',
                  jan_mean: 1.0,
                  feb_mean: 2.0,
                  mar_mean: 3.0,
                  apr_mean: 4.0,
                  may_mean: 5.0,
                  jun_mean: 6.0,
                  jul_mean: 7.0,
                  aug_mean: 8.0,
                  sep_mean: 9.0,
                  oct_mean: 10.0,
                  nov_mean: 11.0,
                  dec_mean: 12.0 }
  end

  def marked_line_for(loc)
    "#{Puller::Location::Processor::MARKER} for years 1991 to 2015 ,"\
    "#{loc[:jan_mean]},#{loc[:feb_mean]},#{loc[:mar_mean]},"\
    "#{loc[:apr_mean]},#{loc[:may_mean]},#{loc[:jun_mean]},"\
    "#{loc[:jul_mean]},#{loc[:aug_mean]},#{loc[:sep_mean]},"\
    "#{loc[:oct_mean]},#{loc[:nov_mean]},#{loc[:dec_mean]},"\
    '12.3,24,1991,2015)'
  end

  def header_line_for(loc)
    %("Monthly Climate Statistics for '#{loc[:name]}' [#{loc[:id]}]")
  end

  describe '.data_in' do
    context 'with no lines' do
      let(:lines) { [] }

      it 'is expected to fail' do
        expect { Puller::Location::Processor.data_in(lines) }.to \
          raise_error(Puller::Location::Processor::FormatError)
      end
    end

    context 'with no header line' do
      let(:lines) { [MONTH_LIST, marked_line_for(AIREYS), DEW_LINE] }

      it 'is expected to fail' do
        expect { Puller::Location::Processor.data_in(lines) }.to \
          raise_error(Puller::Location::Processor::FormatError)
      end
    end

    context 'with no marked data line' do
      let(:lines) { [header_line_for(AIREYS), MONTH_LIST, DEW_LINE] }

      it 'is expected to fail' do
        expect { Puller::Location::Processor.data_in(lines) }.to \
          raise_error(Puller::Location::Processor::FormatError)
      end
    end

    context 'with just the header and one marked line' do
      let(:lines) { [header_line_for(AIREYS), marked_line_for(AIREYS)] }

      it 'is expected to return data for the location' do
        expect(Puller::Location::Processor.data_in(lines)).to eq(AIREYS)
      end
    end

    context 'with lots of lines including a header and marked line' do
      let(:lines) do
        [header_line_for(AIREYS), '', MONTH_LIST,
         '', marked_line_for(AIREYS), DEW_LINE]
      end

      it 'is expected to return data for the location' do
        expect(Puller::Location::Processor.data_in(lines)).to eq(AIREYS)
      end
    end

    context 'with lots of lines including a header and many marked lines' do
      let(:lines) do
        [header_line_for(AIREYS), '', MONTH_LIST,
         '', marked_line_for(AIREYS), DEW_LINE,
         marked_line_for(WOOP_WOOP)]
      end

      it 'is expected to return data from the first marked line' do
        expect(Puller::Location::Processor.data_in(lines)).to eq(AIREYS)
      end
    end
  end
end

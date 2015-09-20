require 'spec_helper'
require 'puller/location/spec_helper'

describe Puller::Location::Processor do
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

require 'spec_helper'
require 'tempfile'
require 'puller'

describe Puller do
  it 'has a version number' do
    expect(Puller::VERSION).not_to be nil
  end

  describe '.pull_from' do
    let(:source) do
      { hostname: 'ftp2.bom.gov.au',
        filename: '/anon/gen/fwo/IDA00003.dat',
        user: 'ftp',
        passwd: '' }
    end

    context 'with a real pipeline', speed: 'slow' do
      let(:pipeline) do
        { getter: Puller::Getter,
          processor: Puller::Processor,
          marshaler: Marshal }
      end

      let(:minimum_region_count) { 10 } # Chosen arbitrarily

      it 'actually works', slow: 'network access' do
        result = Puller.pull_from(source, pipeline)

        loaded = Marshal.load(result)
        expect(loaded.size).to be > minimum_region_count
      end
    end

    context 'with a stubbed pipeline' do
      subject { Puller.pull_from(source, pipeline) }

      let(:content) { 'content' }
      let(:data) { 'data' }

      let(:getter) { double('Getter') }
      let(:processor) { double('Processor') }

      let(:expected) { Marshal.dump(data) }

      before(:example) do
        allow(getter).to receive(:get).with(source).once { content }
        allow(processor).to receive(:data_in).with(content).once { data }
      end

      let(:pipeline) do
        { getter: getter,
          processor: processor,
          marshaler: Marshal }
      end

      it 'uses the getter to retrieve data' do
        expect(getter).to receive(:get).with(source)
        is_expected.to eq(expected)
      end

      it 'forwards the content to the processor' do
        expect(processor).to receive(:data_in).with(content)
        is_expected.to eq(expected)
      end

      it 'marshals the processed data with the marshaler' do
        expected # Prevent breaking the expectation bellow:
        expect(Marshal).to receive(:dump).with(data).once.and_call_original
        is_expected.to eq(expected)
      end
    end
  end
end

require 'spec_helper'
require 'tempfile'
require 'puller'

describe Puller do
  it 'has a version number' do
    expect(Puller::VERSION).not_to be nil
  end

  describe '::pull_from' do
    let(:source) do
      { hostname: 'ftp2.bom.gov.au',
        filename: '/anon/gen/fwo/IDA00003.dat',
        user: 'ftp',
        passwd: '' }
    end

    let(:real_pipeline) do
      { getter: Puller::Getter,
        processor: Puller::Processor,
        marshaller: Marshal }
    end

    it 'actually works', slow: 'network access' do
      Puller.pull_from(source, real_pipeline)
    end

    context 'with a stubbed pipeline' do
      subject { Puller.pull_from(source, stub_pipeline) }

      let(:content) { 'content' }
      let(:data) { 'data' }

      let(:getter) { double('Getter') }
      let(:processor) { double('Processor') }

      let(:expected) { Marshal.dump(data) }

      before(:example) do
        allow(getter).to receive(:get).with(source).once { content }
        allow(processor).to receive(:data_in).with(content).once { data }
      end

      let(:stub_pipeline) do
        { getter: getter, processor: processor, marshaller: Marshal }
      end

      it 'uses the getter to retrieve data' do
        expect(getter).to receive(:get).with(source)
        is_expected.to eq(expected)
      end

      it 'forwards the content to the processor' do
        expect(processor).to receive(:data_in).with(content)
        is_expected.to eq(expected)
      end

      it 'marshals the processed data with the marshaller' do
        expected # Prevent breaking the expectation bellow:
        expect(Marshal).to receive(:dump).with(data).once.and_call_original
        is_expected.to eq(expected)
      end
    end
  end
end

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

    before(:context) do
      @destination = Tempfile.new('puller_pull_from_spec_output')
    end

    before(:example) do
      @destination.truncate 0
    end

    it 'actually works', slow: 'network access' do
      Puller.pull_from(source, real_pipeline, @destination)
    end

    context 'with a stubbed pipeline' do
      let(:content) { 'content' }
      let(:data) { 'data' }
      let(:getter) do
        it = double('Getter')
        allow(it).to receive(:get).with(source) { content }
        it
      end
      let(:processor) do
        it = double('Processor')
        allow(it).to receive(:data_in).with(content) { data }
        it
      end
      let(:marshaller) do
        it = double('Marshaller')
        allow(it).to receive(:dump).with(data, @destination) {}
        it
      end
      let(:stub_pipeline) do
        { getter: getter, processor: processor, marshaller: marshaller }
      end

      it 'uses the getter to retrieve data' do
        expect(getter).to receive(:get).with(source)
        Puller.pull_from(source, stub_pipeline, @destination)
      end

      it 'forwards the content to the processor' do
        expect(processor).to receive(:data_in).with(content)
        Puller.pull_from(source, stub_pipeline, @destination)
      end

      it 'marshals the processed data with the marshaller' do
        expect(marshaller).to receive(:dump).with(data, @destination)
        Puller.pull_from(source, stub_pipeline, @destination)
      end
    end
  end
end

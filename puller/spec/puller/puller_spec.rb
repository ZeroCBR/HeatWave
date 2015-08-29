require 'spec_helper'
require 'puller'

describe Puller do
  it 'has a version number' do
    expect(Puller::VERSION).not_to be nil
  end

  describe '#pull_from' do
    before(:context) do
      @source = { hostname: 'ftp2.bom.gov.au',
                  filename: '/anon/gen/fwo/IDA00003.dat',
                  port: 21 }
      @directory = 'spec/data'
      @output = "#{@directory}/puller_pull_from_spec_output"
    end

    it 'actually works' do
      Dir.mkdir(@directory) unless Dir.exist?(@directory)
      File.delete(@output) if File.exist?(@output)

      @getter = Puller::Getter
      @processor = Puller::Processor
      @saver = Puller::Saver
      Puller.pull_from(@source, @getter, @processor, @saver, @output)
    end

    context 'with stubs' do
      @content = 'content'
      @data = 'data'

      let(:getter) { double('Getter') }
      let(:processor) { double('Processor') }
      let(:saver) { double('Saver') }

      it 'uses the getter to retrieve data' do
        expect(getter).to receive(:get).with(@source) { @content }
        allow(processor).to receive(:data_from).with(@content) { @data }
        allow(saver).to receive(:save).with(@data, @destination) {}

        Puller.pull_from(@source, getter, processor, saver, @destination)
      end

      it 'forwards the content to the processor' do
        allow(getter).to receive(:get).with(@source) { @content }
        expect(processor).to receive(:data_from).with(@content) { @data }
        allow(saver).to receive(:save).with(@data, @destination) {}

        Puller.pull_from(@source, getter, processor, saver, @destination)
      end

      it 'saves the processed data with the saver' do
        allow(getter).to receive(:get).with(@source) { @content }
        allow(processor).to receive(:data_from).with(@content) { @data }
        expect(saver).to receive(:save).with(@data, @destination) {}

        Puller.pull_from(@source, getter, processor, saver, @destination)
      end
    end
  end
end

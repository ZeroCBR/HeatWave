require 'spec_helper'
require 'tempfile'
require 'net/ftp'
require 'fake_ftp'

describe Puller::Getter do
  describe '.get' do
    subject { Puller::Getter.get(source) }

    before(:context) do
      @filename = '/anon/gen/fwo/IDA00003.dat'
      @user = 'ftp'
      @passwd = ''
    end

    context 'with a stubbed ftp server' do
      subject { Puller::Getter.get(source) }

      before(:context) do
        @port = 21_212

        @empty_content = ''
        @single_content = 'this is a test file with test content'
        @single_newline_content = "this is a test file with test content\n"
        @multi_content = "this is a test\nfile with test content"

        @empty_filename = '/anon/gen/fwo/IDA00001.dat'
        @single_filename = '/anon/gen/fwo/IDA00002.dat'
        @single_newline_filename = '/anon/gen/fwo/IDA00003.dat'
        @multi_filename = '/anon/gen/fwo/IDA00004.dat'

        @server = FakeFtp::Server.new(@port, @port + 1)
        @server.start
        @server.add_file(@empty_filename, @empty_content)
        @server.add_file(@single_filename, @single_content)
        @server.add_file(@single_newline_filename, @single_newline_content)
        @server.add_file(@multi_filename, @multi_content)
      end

      let(:source) do
        { hostname: 'localhost',
          port: @port,
          filename: @filename,
          user: @user,
          passwd: @passwd }
      end

      after(:context) do
        @server.stop
      end

      it 'is expected to equal the lines of an empty file' do
        source[:filename] = @empty_filename
        is_expected.to eq @empty_content.lines.map(&:strip)
      end

      it 'is expected to equal the lines of single line file' do
        source[:filename] = @single_filename
        is_expected.to eq @single_content.lines.map(&:strip)
      end

      it 'is expected to equal the lines of a newline terminated file' do
        source[:filename] = @single_newline_filename
        is_expected.to eq @single_newline_content.lines.map(&:strip)
      end

      it 'is expected to equal the lines of multiline file' do
        source[:filename] = @multi_filename
        is_expected.to eq @multi_content.lines.map(&:strip)
      end
    end

    context 'with real ftp', speed: 'slow' do
      before(:context) do
        @hostname = 'ftp2.bom.gov.au'
      end

      let(:source) do
        { hostname: @hostname,
          filename: @filename,
          user: @user,
          passwd: @passwd }
      end

      it 'is expected to equal the ftp result' do
        ftp = Net::FTP.open(@hostname, @user, @passwd)
        ftp_destination = Tempfile.new('puller_getter_ftp_destination')
        ftp.gettextfile(@filename, ftp_destination.path)
        the_ftp_result = ftp_destination.readlines.map(&:strip)

        is_expected.to eq(the_ftp_result)
      end
    end
  end
end

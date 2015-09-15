require 'spec_helper'
require 'tempfile'
require 'net/ftp'
require 'fake_ftp'

describe Puller::Getter do
  describe '.get' do
    subject { Puller::Getter.get(source) }

    HOSTNAME = 'ftp2.bom.gov.au'
    FILENAME = '/anon/gen/fwo/IDA00003.dat'
    USER = 'ftp'
    PASSWD = ''

    let(:source) do
      { hostname: HOSTNAME,
        filename: FILENAME,
        user: USER,
        passwd: PASSWD }
    end

    context 'with a stubbed ftp server' do
      subject { Puller::Getter.get(source) }

      before(:context) do
        @port = 21_212

        @empty_content = "\n"
        @single_content = "this is a test file with test content\n"
        @multi_content = "this is a test\nfile with test content\n"

        @empty_filename = '/anon/gen/fwo/IDA00001.dat'
        @single_filename = '/anon/gen/fwo/IDA00002.dat'
        @multi_filename = '/anon/gen/fwo/IDA00003.dat'

        @server = FakeFtp::Server.new(@port, @port + 1)
        @server.start
        @server.add_file(@empty_filename, @empty_content)
        @server.add_file(@single_filename, @single_content)
        @server.add_file(@single_newline_filename, @single_newline_content)
        @server.add_file(@multi_filename, @multi_content)
      end

      before(:example) do
        source[:hostname] = 'localhost'
        source[:port] = @port
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

      it 'is expected to equal the lines of multiline file' do
        source[:filename] = @multi_filename
        is_expected.to eq @multi_content.lines.map(&:strip)
      end
    end

    context 'with real ftp', speed: 'slow' do
      it 'is expected to equal the ftp result' do
        ftp = Net::FTP.open(HOSTNAME, USER, PASSWD)
        ftp.passive = true
        ftp_result = []
        ftp.gettextfile(FILENAME, nil) { |line| ftp_result << line.strip }
        is_expected.to eq(ftp_result)
      end
    end
  end
end

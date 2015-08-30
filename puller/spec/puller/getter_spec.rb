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

      let(:source) do
        { hostname: 'localhost',
          port: @port,
          filename: @filename,
          user: @user,
          passwd: @passwd }
      end

      before(:context) do
        @port = 21212 # rubocop:disable Style/NumericLiterals
        @content = 'the is a test file with test content'
        @server = FakeFtp::Server.new(@port, @port + 1)
        @server.start
        @server.add_file(@filename, @content)
      end

      after(:context) do
        @server.stop
      end

      it 'is expected to equal the lines of the file content' do
        is_expected.to eq(@content.lines)
      end
    end

    context 'with real ftp', slow: 'network access' do
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
        the_ftp_result = ftp_destination.readlines

        is_expected.to eq(the_ftp_result)
      end
    end
  end
end

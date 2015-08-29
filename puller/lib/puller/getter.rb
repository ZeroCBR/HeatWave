require 'net/ftp'
require 'tempfile'
module Puller
  ##
  # Retrieves weather data from a specified source.
  module Getter
    def self::get(source)
      source[:port] ||= 21
      ftp = Net::FTP.new
      ftp.connect(source[:hostname], source[:port])
      ftp.login(source[:user], source[:passwd])

      ftp_destination = Tempfile.new('puller_getter_destination')
      ftp.gettextfile(source[:filename], ftp_destination.path)

      ftp_destination.readlines
    end
  end
end

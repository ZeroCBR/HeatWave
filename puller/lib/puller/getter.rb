require 'net/ftp'
require 'tempfile'
module Puller
  ##
  # Retrieves content from files accessed over ftp.
  #
  module Getter
    ##
    # Retrieves line-by-line content from a specified source using ftp.
    #
    # ==== Parameters
    #
    # * +source+ - a hash containing:
    #   * +:hostname+ - the hostname of the source ftp server.
    #   * +:port+ - the port with which to connect to the ftp server.
    #   * +:user+ - the username for logging in to the ftp server.
    #   * +:passwd+ - the password for logging in to the ftp server.
    #   * +:filename+ - the name of the file on the ftp server to
    #     retrieve.
    #
    # ==== Returns
    #
    # * An array containing the lines of the file which was retrieved.
    #
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

require 'net/http'

module Puller
  module Location
    ##
    # Retrieves content from files accessed over http.
    #
    module Getter
      ##
      # Retrieves line-by-line content from a specified source using http.
      #
      # ==== Parameters
      #
      # * +source+ - a URI to send a request for.
      #
      # ==== Returns
      #
      # * An array containing the lines of the file which was retrieved,
      #   with trailing whitespace stripped.
      #
      # ==== Raises
      #
      # * +Net::HTTPBadResponse+ if the source cannot be accessed with
      #   an HTTPOK (200) response.
      #
      def self::get(source)
        response = Net::HTTP.get_response(source)
        fail Net::HTTPBadResponse, response unless response.is_a? Net::HTTPOK

        response.body.lines.map(&:strip)
      end
    end
  end
end

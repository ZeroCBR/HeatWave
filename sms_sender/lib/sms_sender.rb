require "sms_sender/version"

require 'rest_client'
require 'json'

module SmsSender

  URL = "https://staging.api.telstra.com/v1/oauth/token?"\
      "client_id=#{client_id}&client_secret=#{client_secret}"\
    "&grant_type=client_credentials&scope=SMS"

  def get_token(c_id, c_secret, rest_client)
    # get an hour-long session token
    resp = rest_client.get "https://staging.api.telstra.com/v1/oauth/token?"\
      "client_id=#{client_id}&client_secret=#{client_secret}"\
    "&grant_type=client_credentials&scope=SMS"

    JSON.parse(resp)["access_token"]
  end

  def send_sms(number, body, rest_client)
      header =  {authorization: "Bearer #{token}",
                 "Content-Type" => "application/json",
                 "Accept" => "application/json"}
      #and send the message, with the header to Telstra
      rest_client.post "https://staging.api.telstra.com/v1/sms/messages",
        {to: number, body: body }.to_json, header
    end
    module_function :send_sms

  end
  #sends 'hello' to James's number (please don't bombard me)
  class TestSender
    include SmsSender
    def trySending
      get_token(
      send_sms("0400400269", "Hello")
    end
  end

  TestSender.new.trySending

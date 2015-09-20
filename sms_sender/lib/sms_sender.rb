require "sms_sender/version"

require 'rest_client'
require 'json'

module SmsSender




  def get_token(c_id, c_secret, rest_client)
    # get an hour-long session token
    resp = rest_client.get "https://staging.api.telstra.com/v1/oauth/token?"\
      "client_id=#{c_id}"\
      "&client_secret=#{c_secret}"\
      "&grant_type=client_credentials&scope=SMS"

    JSON.parse(resp)["access_token"]
  end

  def send_sms( token, number, body, rest_client)
      header =  {authorization: "Bearer #{token}",
                 "Content-Type" => "application/json",
                 "Accept" => "application/json"}
      #and send the message, with the header to Telstra
        rest_client.post "https://staging.api.telstra.com/v1/sms/messages", 
        {to: number, body: body }.to_json, header
  end


  end
  
  class ExampleSender
    include SmsSender

    CLIENT_ID = "jiUppg79kSishjRu6OSkk8k2LCTm7VJE" 
    CLIENT_SECRET = "LLPYNnRboAj1pBtQ"
    
    def trySending(number, body )
      token = get_token(CLIENT_ID ,CLIENT_SECRET, RestClient)
      send_sms(token, number, body, RestClient)
    end
  end

ExampleSender.new.trySending("0400400269", "hello")
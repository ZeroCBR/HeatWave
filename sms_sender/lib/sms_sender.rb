require "sms_sender/version"

require 'rest_client'
require 'json'

module SmsSender

	def send_sms(number, body)
		#these two keys are linked to our dev.telstra account 
  		client_id = "jiUppg79kSishjRu6OSkk8k2LCTm7VJE"
		client_secret = "LLPYNnRboAj1pBtQ"
		# get an hour-long session token
		resp = RestClient.get "https://staging.api.telstra.com/v1/oauth/token?"\
		"client_id=#{client_id}&client_secret=#{client_secret}"\
		"&grant_type=client_credentials&scope=SMS"
		token = JSON.parse(resp)["access_token"]	

		# put that token into a header
    	header =  {authorization: "Bearer #{token}",
    		"Content-Type" => "application/json",
    		"Accept" => "application/json"}
    	#and send the message, with the header to Telstra		
	 	RestClient.post "https://staging.api.telstra.com/v1/sms/messages",
	 		{to: number, body: body }.to_json, header
	end
	module_function :send_sms

end
#sends 'hello' to James's number (please don't bombard me)
class TestSender
	include SmsSender
	def trySending
		send_sms("0400400269", "Hello")
	end
end

TestSender.new.trySending

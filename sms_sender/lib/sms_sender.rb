
require 'sms_sender/version'

require 'rest_client'
require 'json'

##
# SmsSender interacts with Telstra's Dev Sms gateway API.
#
module SmsSender
  ##
  # uses the Telsta
  #
  # ==== Parameters
  #
  # * +c_id+ - our Client ID with he API
  # * +c_secret+ - the passphrase associated with our account.
  # * +rest_client+ - the object through which to post the request
  #
  # ==== Returns
  #
  # * The token with which we may access the API
  #
  def self::get_token(client_id, client_secret, rest_client)
    # get an hour-long session token
    resp = rest_client.get 'https://staging.api.telstra.com/v1/oauth/token?'\
      "client_id=#{client_id}"\
      "&client_secret=#{client_secret}"\
      '&grant_type=client_credentials&scope=SMS'

    JSON.parse(resp)['access_token']
  end
  ##
  # send_sms does the actual sending when given a token and the number/body
  #
  # ==== Parameters
  #
  # * +token+ - the authentication token as a string.
  # * +number+ - the phone number in '04XXXXXXXX' or '614XXXXXXXX' format.
  # * +body+ - the text of the message.
  # * +rest_client+ - the object through which to post the request
  #
  # ==== Returns
  #
  # * The message ID given by Telstra for use with replies
  #

  def self::send_sms(token, number, body, rest_client)
    header = { authorization: "Bearer #{token}",
               'Content-Type' => 'application/json',
               'Accept'       => 'application/json' }
    # and send the message, with the header to Telstra
    resp = rest_client.post 'https://staging.api.telstra.com/v1/sms/messages',
                            { to: number, body: body }.to_json,
                            header

    JSON.parse(resp)['messageId']
  end
end

##
# an example class that implements this module
#
class ExampleSender
  include SmsSender
  CLIENT_ID = 'jiUppg79kSishjRu6OSkk8k2LCTm7VJE'
  CLIENT_SECRET = 'LLPYNnRboAj1pBtQ'
  ##
  # send takes the number/body and sends it to Telstra
  #
  # ==== Parameters
  #
  # * +number+ - the phone number in '04XXXXXXXX' or '614XXXXXXXX' format.
  # * +body+ - the text of the message.
  #
  # ==== Returns
  #
  # * The message ID given by Telstra for use with replies
  #
  def send(number, body)
    token = SmsSender.get_token(CLIENT_ID, CLIENT_SECRET, RestClient)
    SmsSender.send_sms(token, number, body, RestClient)
  end

  ##
  # send takes a list of Numbers and sends one message to each of them
  #
  # ==== Parameters
  #
  # * +number_list+ - A list of the phone numbers
  #   in '04XXXXXXXX' or '614XXXXXXXX' format.
  # * +body+ - the text of the message.
  #
  # ==== Returns
  #
  # * A list of the message ID given by Telstra for use with replies
  #
  def send_many(number_list, body)
    token = SmsSender.get_token(CLIENT_ID, CLIENT_SECRET, RestClient)
    responses = []
    number_list.each do |number|
      responses << SmsSender.send_sms(token, number, body, RestClient)
    end
  end
end

require 'rspec'
require 'json'
require 'sms_sender'

describe SmsSender do

  it 'has a version number' do
    expect(SmsSender::VERSION).not_to be nil
  end

  let(:client_id) { 'jiUppg79kSishjRu6OSkk8k2LCTm7VJE' }
  let(:client_secret) { 'LLPYNnRboAj1pBtQ' }
  let(:rest_client) { double('RestClient') }
  let(:want) { '{ "access_token": "asdA" }' }

    it 'should forward the token request' do
      url = 'https://staging.api.telstra.com/v1/oauth/token?'\
      "client_id=#{client_id}"\
      "&client_secret=#{client_secret}"\
      '&grant_type=client_credentials&scope=SMS'
      allow(rest_client).to receive(:get).with(url).once { want }
      got = SmsSender.get_token(client_id, client_secret, rest_client)
      expect(got).to eq(JSON.parse(want)['access_token'])
    
  end

  let(:destination) { 'https://staging.api.telstra.com/v1/sms/messages' }
  
    it 'should post the message using the token' do
      token = '1234567890'
      body = 'hello'
      number = '0400400269'
      json_string = { to: number, body: body }.to_json
      header = { authorization: "Bearer #{token}",
                 'Content-Type' => 'application/json',
                 'Accept'       => 'application/json' }

      expect(rest_client).to receive(:post).with(
        destination,
        json_string,
        header
      ).once { '{"messageId":"asygsevfka"}' }

      SmsSender.send_sms(token, number, body, rest_client)
    end
  
end

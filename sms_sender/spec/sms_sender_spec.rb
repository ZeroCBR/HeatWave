require 'rspec'

describe 'SmsSender' do

  let(:client_id) { "jiUppg79kSishjRu6OSkk8k2LCTm7VJE" }
  let(:client_secret) { "LLPYNnRboAj1pBtQ" }
  let(:rest_client) { double('RestClient') }
  let(:want) { '{ "asdasd": "asdA" }' }

  describe '#send_sms' do

    it 'should forward the request' do
      allow(rest_client).to receive(:get).with(url).once { want }
      got = get_token(client_id, client_secret, rest_client)
      expect(got).to eq(JSON.want)
    end

  end

end

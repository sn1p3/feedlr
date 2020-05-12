require 'helper'

describe Feedlr::Gateway::Webhooks, vcr: { record: :new_episodes } do
  let(:client) { Feedlr::Client.sandbox(oauth_access_token: access_token) }

  describe '#webhooks'  do
    it 'sends a get request' do
      stub = stub_request(:get, 'http://sandbox.feedly.com/v3/enterprise/triggers')

      client.webhooks
      expect(stub).to have_been_requested
    end
  end

  describe '#webhooks_create' do
    it 'sends a post request' do
      trigger_params = {
        type: 'NewAnnotation',
        webhookURL: 'https://localhost:3000/webhooks',
        resourceId: 'global.all',
        disabled: false
      }

      stub = stub_request(:post,
                          'http://sandbox.feedly.com/v3/enterprise/triggers')
      .with(body: MultiJson.dump(trigger_params))

      client.webhooks_update(trigger_params)
      expect(stub).to have_been_requested
    end
  end

  describe '#webhooks_delete' do
    it 'sends a delete request' do
      trigger_id = 123

      stub = stub_request(:delete,
                          "http://sandbox.feedly.com/v3/enterprise/triggers/#{trigger_id}")
      client.webhooks_delete(trigger_id)
      expect(stub).to have_been_requested
    end
  end
end

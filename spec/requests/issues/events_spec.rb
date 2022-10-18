require 'rails_helper'

RSpec.describe 'Issues::Events', type: :request do
  include WebhookAuthHelper

  describe 'POST /issues/events' do
    before(:all) do
      @payload = file_fixture("issue_event.json").read
    end

    it 'calls for issue event processing' do
      signature = generate_internal_signature(@payload)

      expect(Issues).to receive(:process_event!).with(JSON.parse(@payload).to_h)

      post '/issues/events', params: @payload, headers: {'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json', 'X-Hub-Signature-256' => signature}

      expect(response).to have_http_status(202)
    end

    it 'returns 403 when not authorized' do
      signature = 'sha256=foo'

      post '/issues/events', params: @payload, headers: {'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json', 'X-Hub-Signature-256' => signature}

      expect(response).to have_http_status(403)
    end
  end
end

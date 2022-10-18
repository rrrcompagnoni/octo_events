require 'rails_helper'

RSpec.describe 'Issues::Events', type: :request do
  describe 'POST /issues/events' do
    it 'calls for issue event processing' do
      payload = file_fixture("issue_event.json").read

      expect(Issues).to receive(:process_event!).with(JSON.parse(payload).to_h)

      post '/issues/events', params: payload, headers: {'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json'}

      expect(response).to have_http_status(202)
    end
  end
end

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

  describe 'GET /issues/:issue_number/events' do
    before(:all) do
      user = BasicAuthHelper.user
      password = BasicAuthHelper.password
      encoded = Base64.encode64("#{user}:#{password}")

      @basic_auth_headers = { "Authorization" => "Basic #{encoded}" }
    end

    it 'returns the list of events of an issue' do
      issue_number = 1

      event_1 = Issues::Event.create!(
        issue: {'url' => 'foo'},
        happened_at: DateTime.current,
        issue_number: issue_number,
        action: 'created'
      )

      event_2 = Issues::Event.create!(
        issue: {'url' => 'foo'},
        happened_at: DateTime.current,
        issue_number: issue_number,
        action: 'edited'
      )

      get "/issues/#{issue_number}/events", headers: @basic_auth_headers

      expect(response).to have_http_status(200)

      edited_event, created_event = JSON.parse(response.body)

      expect(created_event['id']).to eq(event_1.id)
      expect(edited_event['id']).to eq(event_2.id)
    end

    it 'returns an empty collection when issue is not found' do
      get "/issues/2/events", headers: @basic_auth_headers

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq([])
    end

    it 'overrides the default pagination params' do
      issue_number = 1

      event_1 = Issues::Event.create!(
        issue: {'url' => 'foo'},
        happened_at: DateTime.current,
        issue_number: issue_number,
        action: 'created'
      )

      event_2 = Issues::Event.create!(
        issue: {'url' => 'foo'},
        happened_at: DateTime.current,
        issue_number: issue_number,
        action: 'edited'
      )

      get "/issues/#{issue_number}/events?page[number]=1&page[size]=1", headers: @basic_auth_headers

      json_response = JSON.parse(response.body)

      edited_event, _ = json_response

      expect(json_response.size).to eq(1)
      expect(edited_event['id']).to eq(event_2.id)

      get "/issues/#{issue_number}/events?page[number]=2&page[size]=1", headers: @basic_auth_headers

      json_response = JSON.parse(response.body)

      created_event, _ = json_response

      expect(json_response.size).to eq(1)
      expect(created_event['id']).to eq(event_1.id)
    end
  end
end

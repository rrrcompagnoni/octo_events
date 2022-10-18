require 'rails_helper'

RSpec.describe 'Issues', type: :model do
  before(:all) do
    @attributes = JSON.parse(file_fixture("issue_event.json").read)
  end

  describe '.process_event!' do
    it 'raises error when the payload miss the issue attribute' do
      expect { Issues.process_event!({"action" => "opened"}) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Issue can't be blank")
    end

    it 'saves a raw event to the DB' do
      expect { Issues.process_event!(@attributes) }.to change { Issues::RawEvent.count }.from(0).to(1)
    end

    it 'calls for async event processing' do
      allow(Issues::ProcessEventJob).to receive(:perform_later)

      result = Issues.process_event!(@attributes)

      expect(Issues::ProcessEventJob).to have_received(:perform_later).with(result.raw_event_id)
    end

    it 'returns the raw event id in the response' do
      response = Issues.process_event!(@attributes)

      expect(response.raw_event_id).to be_kind_of(Integer)
    end
  end

  describe '.create_event!' do
    it 'saves an event based on a raw event previously created' do
      raw_event = Issues::RawEvent.create!(payload: @attributes)

      event = Issues.create_event!(raw_event.id)

      expect(event.attributes).to include({
        "action" => raw_event.action,
        "issue_number" => raw_event.issue_number.to_s,
        "happened_at" => raw_event.created_at,
        "issue" => raw_event.issue
      })
    end
  end
end

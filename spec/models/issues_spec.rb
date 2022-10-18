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

  describe '.list_events' do
    it 'returns an empty list when there are no events for an issue' do
      expect(Issues.list_events('1')).to eq([])
    end

    it 'returns an ordered array by the most recent event first' do
      event_1 = Issues::Event.create!(
        issue: {'url' => 'foo'},
        happened_at: DateTime.current,
        issue_number: '1',
        action: 'created'
      )

      event_2 = Issues::Event.create!(
        issue: {'url' => 'foo'},
        happened_at: DateTime.current,
        issue_number: '1',
        action: 'edited'
      )

      # edited event is the most recent
      edited_event, created_event = Issues.list_events('1')

      expect(edited_event.id).to eq(event_2.id)
      expect(created_event.id).to eq(event_1.id)
    end

    it 'has a default pagination' do
      events = Issues.list_events('1')

      expect(events.current_page).to eq(1)
      expect(events.limit_value).to eq(20)
    end

    it 'overrides the default pagination when given' do
      events = Issues.list_events('1', {number: 2, size: 1})

      expect(events.current_page).to eq(2)
      expect(events.limit_value).to eq(1)
    end
  end
end

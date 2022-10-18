require 'rails_helper'

RSpec.describe Issues::ProcessEventJob, type: :job do
  describe '#perform' do
    it 'calls for event creation' do
      raw_event = Issues::RawEvent.create!(
        payload: {
          'action' => 'created',
          'issue' => {
            'url' => 'foo'
          }
        }
      )

      expect(Issues).to receive(:create_event!).with(raw_event.id)

      Issues::ProcessEventJob.new().perform(raw_event.id)
    end
  end
end

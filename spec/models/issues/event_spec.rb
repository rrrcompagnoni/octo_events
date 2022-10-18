require 'rails_helper'

RSpec.describe Issues::Event, type: :model do
  describe 'attribute presence validation' do
    it 'is invalid without an action' do
      event = Issues::Event.new(
        issue: {'url' => 'foo'},
        happened_at: DateTime.current,
        issue_number: '1'
      )

      event.valid?

      expect(event.errors[:action]).to include("can't be blank")
    end

    it 'is invalid without an issue' do
      event = Issues::Event.new(
        happened_at: DateTime.current,
        issue_number: '1',
        action: 'created'
      )

      event.valid?

      expect(event.errors[:issue]).to include("can't be blank")
    end

    it 'is invalid without a happened_at' do
      event = Issues::Event.new(
        issue: {'url' => 'foo'},
        issue_number: '1',
        action: 'created'
      )

      event.valid?

      expect(event.errors[:happened_at]).to include("can't be blank")
    end

    it 'is invalid without an issue_number' do
      event = Issues::Event.new(
        issue: {'url' => 'foo'},
        happened_at: DateTime.current,
        action: 'created'
      )

      event.valid?

      expect(event.errors[:issue_number]).to include("can't be blank")
    end
  end
end

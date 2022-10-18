require 'rails_helper'

RSpec.describe Issues::RawEvent, type: :model do
  describe 'presence validations' do
    it 'is invalid when the issue attribute on payload is missing' do
      expect(Issues::RawEvent.new(payload: {"action" => "closed"})).to be_invalid
    end
  end

  describe 'action types inclusion validation' do
    it 'does not return error within types included in the allow list' do
      %w(
        opened
        edited
        deleted
        pinned
        unpinned
        closed
        reopened
        assigned
        unassigned
        labeled
        unlabeled
        locked
        unlocked
        transferred
        milestoned
        demilestoned
        created
      ).each do |action_type|
        expect(Issues::RawEvent.new(
          payload:
            {
              "issue" => {
                "url" => "https://api.github.com/repos/rrrcompagnoni/octo_events/issues/1"
              },
              "action" => action_type
            }
          )
        ).to be_valid
      end
    end
  end
end

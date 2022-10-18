class Issues::RawEvent < ApplicationRecord
  store :payload, accessors: [:action, :issue], coder: JSON

  validates_presence_of :issue
  validates :action, inclusion: {
    in: %w(
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
    )
  }

  def issue_number
    issue['number']
  end
end

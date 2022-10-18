class Issues::Event < ApplicationRecord
  validates_presence_of [:issue_number, :happened_at, :action, :issue]
end

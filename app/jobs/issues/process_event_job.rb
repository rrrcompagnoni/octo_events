class Issues::ProcessEventJob < ApplicationJob
  queue_as :default

  def perform(raw_event_id)
    Issues.create_event!(raw_event_id)
  end
end

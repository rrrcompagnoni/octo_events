module Issues
  ProcessEventResult = Struct.new(:raw_event_id)

  def self.process_event!(raw_attributes)
    raw_event = RawEvent.create!(payload: raw_attributes)

    ProcessEventJob.perform_later(raw_event.id)

    ProcessEventResult.new(raw_event.id)
  end

  def self.create_event!(id)
    raw_event = RawEvent.find(id)

    Event.create!(
      action: raw_event.action,
      issue_number: raw_event.issue_number,
      happened_at: raw_event.created_at,
      issue: raw_event.issue
    )
  end

  def self.list_events(issue_number, page = {})
    Event
      .where(issue_number: issue_number)
      .order(happened_at: :desc)
      .page(page.fetch(:number, '1'))
      .per(page.fetch(:size, '20'))
  end

  def self.table_name_prefix
    "issue_"
  end
end

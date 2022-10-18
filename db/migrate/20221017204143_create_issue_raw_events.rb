class CreateIssueRawEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :issue_raw_events do |t|
      t.jsonb :payload, null: false

      t.timestamps
    end
  end
end

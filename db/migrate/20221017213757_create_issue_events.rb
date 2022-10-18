class CreateIssueEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :issue_events do |t|
      t.string :issue_number, index: true, null: false
      t.string :action, null: false
      t.jsonb :issue, null: false
      t.datetime :happened_at, null: false
    end
  end
end

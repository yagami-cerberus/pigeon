class CreateIssueStatuses < ActiveRecord::Migration
  def change
    create_table :issue_statuses do |t|
      t.string :name, null: false, limit: 64
      t.integer :order, null: false, default: 0
      t.string :mode, null: false, limit: 10
    end
  end
end

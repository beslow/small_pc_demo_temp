class CreateAutomations < ActiveRecord::Migration
  def change
    create_table :automations do |t|
      t.string :name
      t.string :description
      t.integer :part_id
      t.integer :export_type_id
      t.integer :deleter_id
      t.datetime :delete_at
      t.boolean :delete_flag, :default => false
      t.integer :author_id
      t.integer :regenerator_id

      t.timestamps
    end
  end
end

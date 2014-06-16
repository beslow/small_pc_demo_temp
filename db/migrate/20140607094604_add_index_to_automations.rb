class AddIndexToAutomations < ActiveRecord::Migration
  def change
    add_index :automations, :name, unique: true
  end
end

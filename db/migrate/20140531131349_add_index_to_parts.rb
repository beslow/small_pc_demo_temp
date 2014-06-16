class AddIndexToParts < ActiveRecord::Migration
  def change
    add_index :parts, [:company_id, :name], unique: true
  end
end

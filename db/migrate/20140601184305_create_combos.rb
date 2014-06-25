class CreateCombos < ActiveRecord::Migration
  def change
    create_table :combos do |t|
      t.integer :sort
      t.integer :part_id
      t.integer :sub_part_id
      t.boolean :delete_flag, :default => false
      t.integer :author_id
      t.integer :regenerator_id

      t.timestamps
    end
  end
end

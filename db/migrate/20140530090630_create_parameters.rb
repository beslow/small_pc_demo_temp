class CreateParameters < ActiveRecord::Migration
  def change
    create_table :parameters do |t|
      t.integer :part_id
      t.string :name
      t.string :description
      t.boolean :delete_flag
      t.integer :author_id
      t.integer :regenerator_id

      t.timestamps
    end
  end
end

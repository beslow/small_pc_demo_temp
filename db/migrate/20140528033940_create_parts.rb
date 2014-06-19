class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.integer :company_id
      t.integer :property_id
      t.string :no
      t.string :name
      t.integer :partclass_id
      t.integer :type_id
      t.integer :classify_id
      t.string :description
      t.text :content
      t.integer :table_row_num
      t.integer :table_column_num
      t.integer :table_line_type1
      t.integer :table_line_type2
      t.integer :table_line_color
      t.datetime :delete_at
      t.integer :deleter_id
      t.boolean :delete_flag, :default => false
      t.integer :author_id
      t.integer :regenerator_id

      t.timestamps
    end
  end
end

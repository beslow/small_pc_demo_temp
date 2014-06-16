class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.integer :company_id
      t.string :code
      t.string :name
      t.integer :propertyID
      t.boolean :delete_flag
      t.integer :author_id
      t.integer :regenerator_id

      t.timestamps
    end
  end
end

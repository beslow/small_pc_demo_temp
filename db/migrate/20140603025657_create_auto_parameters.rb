class CreateAutoParameters < ActiveRecord::Migration
  def change
    create_table :auto_parameters do |t|
      t.integer :automation_id
      t.integer :parameter_id
      t.string :value

      t.timestamps
    end
  end
end

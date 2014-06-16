class CreatePartclasses < ActiveRecord::Migration
  def change
    create_table :partclasses do |t|
      t.string :name

      t.timestamps
    end
  end
end

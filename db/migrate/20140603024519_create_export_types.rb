class CreateExportTypes < ActiveRecord::Migration
  def change
    create_table :export_types do |t|
      t.string :name

      t.timestamps
    end
  end
end

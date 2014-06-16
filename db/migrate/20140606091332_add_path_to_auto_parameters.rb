class AddPathToAutoParameters < ActiveRecord::Migration
  def change
    add_column :auto_parameters, :path, :string
  end
end

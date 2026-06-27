class AddCodeAndPresentToContestants < ActiveRecord::Migration[7.2]
  def change
    add_column :contestants, :code, :string
    add_column :contestants, :present, :boolean, default: false, null: false
    add_index :contestants, :code, unique: true
  end
end

class CreateContestants < ActiveRecord::Migration[7.2]
  def change
    create_table :contestants do |t|
      t.string :name, null: false
      t.boolean :singing_enabled, default: true, null: false
      t.boolean :costume_enabled, default: true, null: false
      t.integer :position, default: 0, null: false
      t.timestamps
    end
  end
end

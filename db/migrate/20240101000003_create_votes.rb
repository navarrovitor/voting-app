class CreateVotes < ActiveRecord::Migration[7.2]
  def change
    create_table :votes do |t|
      t.references :guest, null: false, foreign_key: true
      t.references :contestant, null: false, foreign_key: true
      t.string :category, null: false
      t.integer :rank, null: false
      t.timestamps
    end
    add_index :votes, [:guest_id, :category, :rank], unique: true
    add_index :votes, [:guest_id, :category, :contestant_id], unique: true
  end
end

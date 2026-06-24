class CreateGuests < ActiveRecord::Migration[7.2]
  def change
    create_table :guests do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :auth_token
      t.datetime :token_expires_at
      t.string :session_token, index: { unique: true }
      t.timestamps
    end
  end
end

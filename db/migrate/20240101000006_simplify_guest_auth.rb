class SimplifyGuestAuth < ActiveRecord::Migration[7.2]
  def change
    add_column :guests, :identifier, :string
    add_column :guests, :contestant_id, :bigint
    add_index :guests, :identifier, unique: true
    add_index :guests, :contestant_id

    # Drop columns that belonged to the email/magic-link flow
    remove_column :guests, :email, :string
    remove_column :guests, :auth_token, :string
    remove_column :guests, :token_expires_at, :datetime

    add_foreign_key :guests, :contestants
  end
end

class Guest < ApplicationRecord
  has_many :votes, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }

  before_validation { self.email = email&.downcase&.strip }

  CATEGORIES = %w[singing costume].freeze

  def generate_auth_token!
    self.auth_token = SecureRandom.urlsafe_base64(32)
    self.token_expires_at = 30.minutes.from_now
    save!
    auth_token
  end

  def authenticate_token!(token)
    return false unless auth_token == token && token_expires_at&.future?
    self.session_token = SecureRandom.urlsafe_base64(32)
    self.auth_token = nil
    self.token_expires_at = nil
    save!
    session_token
  end

  def voted_for?(category)
    votes.where(category: category).count == 3
  end
end

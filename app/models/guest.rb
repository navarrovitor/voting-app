class Guest < ApplicationRecord
  belongs_to :contestant, optional: true
  has_many :votes, dependent: :destroy

  validates :identifier, presence: true, uniqueness: { case_sensitive: false }

  CATEGORIES = %w[singing costume].freeze

  def voted_for?(category)
    votes.where(category: category).count == 3
  end
end

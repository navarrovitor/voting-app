class Vote < ApplicationRecord
  belongs_to :guest
  belongs_to :contestant

  validates :category, inclusion: { in: Guest::CATEGORIES }
  validates :rank, inclusion: { in: [1, 2, 3] }
  validates :rank, uniqueness: { scope: [:guest_id, :category] }
  validates :contestant_id, uniqueness: { scope: [:guest_id, :category] }
  validate :contestant_eligible_for_category

  POINTS = { 1 => 3, 2 => 2, 3 => 1 }.freeze

  private

  def contestant_eligible_for_category
    return unless contestant && category
    field = "#{category}_enabled"
    unless contestant.respond_to?(field) && contestant.public_send(field)
      errors.add(:contestant, "is not eligible for #{category}")
    end
  end
end

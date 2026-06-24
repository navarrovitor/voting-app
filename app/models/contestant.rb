class Contestant < ApplicationRecord
  has_many :votes, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :for_singing, -> { where(singing_enabled: true).order(:position, :name) }
  scope :for_costume, -> { where(costume_enabled: true).order(:position, :name) }
  scope :ordered,     -> { order(:position, :name) }
end

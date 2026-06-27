class Contestant < ApplicationRecord
  has_many :votes, dependent: :destroy

  before_validation :assign_code, on: :create

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :code, presence: true, uniqueness: { case_sensitive: false }

  scope :for_singing, -> { where(present: true, singing_enabled: true).order(:position, :name) }
  scope :for_costume, -> { where(present: true, costume_enabled: true).order(:position, :name) }
  scope :ordered,     -> { order(:position, :name) }

  private

  def assign_code
    self.code ||= generate_unique_code
  end

  def generate_unique_code
    chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
    loop do
      candidate = Array.new(4) { chars[rand(chars.length)] }.join
      break candidate unless Contestant.exists?(code: candidate)
    end
  end
end

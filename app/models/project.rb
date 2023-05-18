class Project < ApplicationRecord
  validates :name, presence: true
  validates :is_done, inclusion: [true, false]

  scope :undone, -> { where(is_done: false) }
  scope :done, -> { where(is_done: true) }

  scope :descend_by_updated_at, -> { order(updated_at: :desc) }
end

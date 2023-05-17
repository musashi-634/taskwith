class Project < ApplicationRecord
  validates :name, presence: true
  validates :is_done, inclusion: [true, false]

  scope :undone, -> { where(is_done: false) }
end

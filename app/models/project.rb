class Project < ApplicationRecord
  validates :name, presence: true
  validates :is_done, inclusion: [true, false]
end

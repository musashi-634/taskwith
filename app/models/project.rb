class Project < ApplicationRecord
  has_many :project_members, dependent: :destroy
  has_many :users, through: :project_members

  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :is_done, inclusion: [true, false]
  validates :is_archived, inclusion: [true, false]

  scope :not_archived, -> { where(is_archived: false) }
  scope :archived, -> { where(is_archived: true) }

  scope :descend_by_updated_at, -> { order(updated_at: :desc) }
end

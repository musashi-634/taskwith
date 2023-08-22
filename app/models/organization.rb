class Organization < ApplicationRecord
  has_many :users

  has_many :projects, dependent: :destroy

  validates :name, presence: true
end

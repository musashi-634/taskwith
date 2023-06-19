class Task < ApplicationRecord
  belongs_to :project

  validates :name, presence: true
  validate :check_period
  validates :is_done, inclusion: [true, false]

  private

  def check_period
    if start_at.nil? || end_at.nil?
      return
    end

    if start_at > end_at
      errors.add(:end_at, "は開始日以降にしてください")
    end
  end
end

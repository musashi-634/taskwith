class Task < ApplicationRecord
  include RankedModel

  belongs_to :project
  ranks :row_order,
    with_same: :project_id # projectごとにscopeを絞ってランク付け

  validates :name, presence: true
  validate :check_period
  validates :is_done, inclusion: [true, false]

  delegate :organization, to: :project

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

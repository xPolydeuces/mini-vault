class TodoItem < ApplicationRecord
  belongs_to :model_set, optional: true
  belongs_to :parent, class_name: 'TodoItem', optional: true

  has_many :subtasks, class_name: 'TodoItem', foreign_key: 'parent_id', dependent: :destroy

  enum :priority, {
    low: 0,
    medium: 1,
    high: 2
  }, prefix: true

  validates :title, presence: true
  validates :estimated_hours, numericality: { greater_than: 0, allow_nil: true }

  scope :incomplete, -> { where(completed: false) }
  scope :completed, -> { where(completed: true) }
  scope :upcoming, -> { incomplete.where('due_date >= ?', Date.current).order(:due_date) }
  scope :overdue, -> { incomplete.where('due_date < ?', Date.current).order(:due_date) }

  def complete!
    update(completed: true, completed_at: Time.current)
  end

  def uncomplete!
    update(completed: false, completed_at: nil)
  end
end
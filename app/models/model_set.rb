class ModelSet < ApplicationRecord
  belongs_to :series, counter_cache: true
  belongs_to :faction, counter_cache: true, optional: true
  belongs_to :parent, class_name: 'ModelSet', optional: true
  belongs_to :user, optional: true

  has_many :children, class_name: 'ModelSet', foreign_key: 'parent_id', dependent: :destroy
  has_many :todo_items, dependent: :destroy
  has_many :painting_batch_model_sets, dependent: :destroy
  has_many :painting_batches, through: :painting_batch_model_sets

  has_many_attached :images

  enum :status, {
    on_sprue: 0,
    in_assembly: 1,
    assembled: 2,
    in_painting: 3,
    painted: 4,
    completed: 5
  }, prefix: true

  enum :priority, {
    low: 0,
    medium: 1,
    high: 2
  }, prefix: true
  
  validates :name, presence: true
  validates :total_models, presence: true, numericality: { greater_than: 0 }
  validates :on_sprue, :in_assembly, :assembled, :in_painting, :painted, :completed,
            numericality: { greater_than_or_equal_to: 0 }
  
  validate :model_counts_sum

  private

  def model_counts_sum
    return unless total_models.present?

    sum = on_sprue + in_assembly + assembled + in_painting + painted 
    if sum > total_models
      errors.add(:base, "The sum of model counts (#{sum}) cannot exceed total models (#{total_models}).")
    end
  end
end
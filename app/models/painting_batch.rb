class PaintingBatch < ApplicationRecord
    has_many :painting_batch_model_sets, dependent: :destroy
    has_many :model_sets, through: :painting_batch_model_sets

    validates :name, presence: true

    scope :active, -> { where(completed_at: nil) }
    scope :completed, -> { where.not(completed_at: nil) }
end
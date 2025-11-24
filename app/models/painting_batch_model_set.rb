class PaintingBatchModelSet < ApplicationRecord
    belongs_to :painting_batch
    belongs_to :model_set

    validates :model_set_id, uniqueness: { scope: :painting_batch_id }
end
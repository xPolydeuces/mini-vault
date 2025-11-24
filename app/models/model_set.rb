class ModelSet < ApplicationRecord
  belongs_to :series, counter_cache: true
  belongs_to :faction, counter_cache: true, optional: true
  belongs_to :parent, class_name: 'ModelSet', optional: true
  belongs_to :user, optional: true

  has_many :children, class_name: 'ModelSet', foreign_key: 'parent_id', dependent: :destroy
  has_many :todo_items, dependent: :destroy
  has_many :painting_batch_model_sets, dependent: :destroy
  has_many :painting_batches, through: :painting_batch_model_sets
  has_many :photos, dependent: :destroy

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

  # Archived reasons
  ARCHIVED_REASONS = %w[for_sale sold given_away other].freeze

  # Scopes
  scope :active, -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }
  scope :for_sale, -> { where(archived: true, archived_reason: 'for_sale') }
  
  validates :name, presence: true
  validates :total_models, presence: true, numericality: { greater_than: 0 }
  validates :on_sprue, :in_assembly, :assembled, :in_painting, :painted, :completed,
            numericality: { greater_than_or_equal_to: 0 }
  
  validate :model_counts_sum

  # Photo convenience methods
  def wip_photos
    photos.photo_type_wip.ordered
  end

  def finished_photos
    photos.photo_type_finished.ordered
  end

  def reference_photos
    photos.photo_type_reference.ordered
  end

  def primary_photo(type = :finished)
    photos.send("photo_type_#{type}").primary_photos.first ||
    photos.send("photo_type_#{type}").ordered.first
  end

  # Archive methods
  def archive!(reason)
    update(archived: true, archived_reason: reason, archived_at: Time.current)
  end

  def unarchive!
    update(archived: false, archived_reason: nil, archived_at: nil)
  end

  def for_sale?
    archived && archived_reason == 'for_sale'
  end

  private

  def model_counts_sum
    return unless total_models.present?

    sum = on_sprue + in_assembly + assembled + in_painting + painted 
    if sum > total_models
      errors.add(:base, "Sum of model counts cannot exceed total models")
    end
  end
end
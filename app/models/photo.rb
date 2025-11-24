class Photo < ApplicationRecord
  belongs_to :model_set
  has_one_attached :image

  enum :photo_type, {
    wip: 0,
    finished: 1,
    reference: 2
  }, prefix: true

  validates :photo_type, presence: true
  validates :image, presence: true

  # Only one primary photo per model_set per type
  validates :primary, uniqueness: { scope: [:model_set_id, :photo_type] }, if: :primary?

  scope :ordered, -> { order(position: :asc, created_at: :desc) }
  scope :primary_photos, -> { where(primary: true) }

  # Automatically set position if not provided
  before_validation :set_position, on: :create, unless: :position

  def mark_as_primary!
    transaction do
      # Unmark other primary photos of the same type
      model_set.photos.where(photo_type: photo_type, primary: true).update_all(primary: false)
      update!(primary: true)
    end
  end

  private

  def set_position
    last_position = model_set.photos.where(photo_type: photo_type).maximum(:position) || -1
    self.position = last_position + 1
  end
end
class Faction < ApplicationRecord
  belongs_to :series, counter_cache: true
  has_many :model_sets, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: { scope: :series_id }
end
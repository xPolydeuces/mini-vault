class Series < ApplicationRecord
  has_many :factions, dependent: :destroy
  has_many :model_sets, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
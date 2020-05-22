class Work < ApplicationRecord
  validates :title, presence: true
  validates_uniqueness_of :title, scope: :category
end

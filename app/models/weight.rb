class Weight < ApplicationRecord
  has_many :pets, inverse_of: :weight
  has_many :lost_dogs
  
  validates :start_weight, numericality: { greater_than: 0 }
  validates :end_weight, numericality: { greater_than: 0 }
end

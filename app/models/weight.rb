class Weight < ApplicationRecord
  has_many :pets, inverse_of: :weight
  has_many :lost_dogs
end

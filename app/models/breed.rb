class Breed < ApplicationRecord
  has_many :pets
  has_many :lost_dogs
end

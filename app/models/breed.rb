class Breed < ApplicationRecord
  has_many :pets
  has_many :lost_dogs
  
  scope :contains, -> (name) {where("name LIKE ?", "%#{name}%")}
end

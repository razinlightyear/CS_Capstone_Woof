class Color < ApplicationRecord
  has_and_belongs_to_many :pets
  #has_and_belongs_to_many :lost_dogs
  
  scope :contains, -> (name) {where("name LIKE ?", "%#{name}%")}
end

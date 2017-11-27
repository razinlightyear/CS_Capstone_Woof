class Breed < ApplicationRecord
  has_many :pets, inverse_of: :breed
  has_many :found_dogs
  
  validates :name, presence: { message: "Please enter a breed name" }
    
  scope :contains, -> (name) {where("name LIKE ?", "%#{name}%")}
end

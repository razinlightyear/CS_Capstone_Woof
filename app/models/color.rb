class Color < ApplicationRecord
  has_and_belongs_to_many :pets, inverse_of: :colors
  #has_and_belongs_to_many :lost_dogs
    
  validates :name, presence: { message: "Please enter a color name" }
    
  scope :contains, -> (name) {where("name LIKE ?", "%#{name}%")}
end

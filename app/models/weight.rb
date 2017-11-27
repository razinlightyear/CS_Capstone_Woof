class Weight < ApplicationRecord
  has_many :pets, inverse_of: :weight
  has_many :lost_dogs
  
  # Map the range to display
  # "10 lbs - 20 lbs"
  def display
    "#{self.start_weight} lbs - #{self.end_weight.nil? ? "up" : "#{self.end_weight} lbs"}"
  end
end

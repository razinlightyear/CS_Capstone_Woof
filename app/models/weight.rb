class Weight < ApplicationRecord
  has_many :pets, inverse_of: :weight
  has_many :lost_dogs
  
  # map the range to display with the id
  # ["10 lbs - 20 lbs", 2]
  def display
    ["#{self.start_weight} lbs - #{self.end_weight.nil? ? "up" : "#{self.end_weight} lbs"}", self.id]
  end
end

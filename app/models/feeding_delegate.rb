class FeedingDelegate < ApplicationRecord
  belongs_to :feeding, inverse_of: :delegate
  
  # any Feeding associations go here. add method names to Feeding class
end

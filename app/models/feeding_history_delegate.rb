class FeedingHistoryDelegate < ApplicationRecord
  belongs_to :feeding_history, inverse_of: :delegate
  
  # any Feeding associations go here. add method names to Feeding class
end

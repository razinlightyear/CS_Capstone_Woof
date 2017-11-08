class PostEventDelegate < ApplicationRecord
  belongs_to :post_event, inverse_of: :delegate
end

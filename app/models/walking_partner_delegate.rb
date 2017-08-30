class WalkingPartnerDelegate < ApplicationRecord
  belongs_to :walking_partner, inverse_of: :delegate
end

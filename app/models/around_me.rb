class AroundMe < ApplicationRecord
  has_one :event, as: :pet_event, dependent: :destroy
  delegate to: :event, prefix: true
  belongs_to :around_me_event, polymorphic: true
end

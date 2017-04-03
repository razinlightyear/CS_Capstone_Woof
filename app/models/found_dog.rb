class FoundDog < ApplicationRecord
  has_one :around_me, as: :around_me_event, dependent: :destroy
  delegate :longitude, :latitude, to: :around_me
  has_and_belongs_to_many :colors
  belongs_to :breed
  belongs_to :weight
end

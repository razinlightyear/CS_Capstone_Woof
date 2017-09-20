class Pet < ApplicationRecord
  belongs_to :group
  belongs_to :breed
  belongs_to :weight
  has_and_belongs_to_many :colors
  has_many :events
  
  scope :active, -> {where(active: true)}
end
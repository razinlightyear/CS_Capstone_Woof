class Pet < ApplicationRecord
  belongs_to :group
  belongs_to :breed
  belongs_to :weight
  has_and_belongs_to_many :colors
  has_many :events
  has_many :nudges
  
  validates :group, presence: { message: "This pet must be belong to a group" }
  validates :colors, presence: { message: "Please select the color(s) of the pet" }
  validates :breed, presence: { message: "Please select a breed" }
  validates :weight, presence: { message: "Please select a weight range" }
  validates :name, presence: { message: "Please enter a name for the pet" }
  
  scope :active, -> {where(active: true)}
end

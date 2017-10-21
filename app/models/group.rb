class Group < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  has_and_belongs_to_many :users
  has_many :pets, inverse_of: :group
  has_many :feeding_histories
  has_many :nudges
  
  validates :name, presence: { message: "Please enter a group name" }
  validates :owner, presence: true
end

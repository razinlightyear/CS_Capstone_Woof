class User < ApplicationRecord
  has_many :owns_groups, class_name: "Group", foreign_key: "owner_id"
  has_and_belongs_to_many :groups
  has_many :events
  has_secure_password # password_digest field on db, password & password_confirmation attributes on model, & authenticated through the authenticate method
  
  scope :active, -> {where(active: true)}
end

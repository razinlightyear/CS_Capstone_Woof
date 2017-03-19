class User < ApplicationRecord
  has_many :owns_groups, class_name: "Group", foreign_key: "owner_id"
  has_and_belongs_to_many :groups
  has_secure_password
end

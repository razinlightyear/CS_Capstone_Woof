class User < ApplicationRecord
  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :timeoutable

=begin        
Database Authenticable
Registerable
Rememberable
Timeoutable
=end

  has_many :owns_groups, class_name: "Group", foreign_key: "owner_id"
  has_and_belongs_to_many :groups
  has_many :events
  
  scope :active, -> {where(active: true)}
end

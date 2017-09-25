class User < ApplicationRecord
  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :timeoutable

  has_many :owns_groups, class_name: "Group", foreign_key: "owner_id"
  has_and_belongs_to_many :groups
  has_many :events

  validates :first_name, :last_name, presence: true

  # I need to work more on the regular expression
  VALID_EMAIL_REGEX = /\A[\w\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, confirmation: true, length: { minimum: 6}
  validates :password_confirmation, presence: true

  scope :active, -> {where(active: true)}
end

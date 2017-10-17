class User < ApplicationRecord
  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :timeoutable

  has_many :owns_groups, class_name: "Group", foreign_key: "owner_id", inverse_of: :owner # as an owner you can also have many groups
  has_and_belongs_to_many :groups
  has_many :events, inverse_of: :user
  has_many :devices
  
  #validates :password, length: { minimum: 6, message: "Password must be at least 6 characters" } # if devise wants something different, feel free to change
  validates :email, presence: { message: "Please enter an email" }, uniqueness: true # by confirming through the email, you know the email format is correct (no need for regex)
  validates :email, uniqueness: { message: "This email is already registered" }

  validates :password, presence: true, confirmation: true, length: { minimum: 6 }, unless: "password.nil?"
  validates :password_confirmation, presence: true, if: "id.nil?"

  scope :active, -> {where(active: true)}
end

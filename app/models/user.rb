class User < ApplicationRecord
  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :timeoutable, :confirmable

  has_many :owns_groups, class_name: "Group", foreign_key: "owner_id", inverse_of: :owner # as an owner you can also have many groups
  has_and_belongs_to_many :groups
  has_many :events, inverse_of: :user
  has_many :sent_group_invites, class_name: "GroupInvite", foreign_key: "inviter_id", inverse_of: :inviter_id
  has_many :received_group_invites, class_name: "GroupInvite", foreign_key: "invitee_id", inverse_of: :invitee_id
  
  #validates :password, length: { minimum: 6, message: "Password must be at least 6 characters" } # if devise wants something different, feel free to change
  validates :email, presence: { message: "Please enter an email" }, uniqueness: true # by confirming through the email, you know the email format is correct (no need for regex)
  validates :email, uniqueness: { message: "This email is already registered" }

  validates :password, presence: true, confirmation: true, length: { minimum: 6 }, unless: "password.nil?"
  validates :password_confirmation, presence: true, if: "id.nil?"

  scope :active, -> {where(active: true)}
  scope :public_account, -> {where(private: [nil,false])}
  scope :first_name_contains, -> (name) {where("first_name LIKE ?", "%#{name}%")}
  scope :last_name_contains, -> (name) {where("last_name LIKE ?", "%#{name}%")}
  scope :email_contains, -> (name) {where("email LIKE ?", "%#{name}%")}
  scope :contains, -> (name) {
                               first_name_contains(name)
                               .or(last_name_contains(name))
                               .or(email_contains(name))
                               .public_account
                             }
  scope :contains_not_in_group, -> (name, group_id) {
                                                      contains(name)
                                                     .where.not(id: User.select(:id)
                                                                        .joins(:groups)
                                                                        .where('groups.id' => group_id))
                                                    }
                                                    
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end

class GroupInvite < ApplicationRecord
  belongs_to :inviter, class_name: "User", foreign_key: "inviter_id"
  belongs_to :invitee, class_name: "User", foreign_key: "invitee_id"
  belongs_to :group
  
  validates :inviter, :invitee, :group, presence: true
  
  before_create :generate_invite_token
  
  private
  
  def generate_invite_token
    if self.invite_token # && !confirmation_period_expired?
      self.invite_token
    else
      self.invite_token = Devise.friendly_token
    end
  end
end

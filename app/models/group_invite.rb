class GroupInvite < ApplicationRecord
  belongs_to :inviter, class_name: "User", foreign_key: "inviter_id"
  belongs_to :invitee, class_name: "User", foreign_key: "invitee_id"
  belongs_to :group
  
  validates :inviter, :invitee, :group, presence: true
end

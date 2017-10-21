# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def group_invite
    UserMailer.group_invite(GroupInvite.eager_load(:group, :invitee, :inviter).first)
  end
  
  def group_invite_new_user
    UserMailer.group_invite_new_user(GroupInvite.eager_load(:group, :invitee, :inviter).first)
  end
end

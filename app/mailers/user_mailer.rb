class UserMailer < ApplicationMailer
  
  def group_invite(group_invite)
    @group_invite = group_invite
    email_with_name = %("#{@group_invite.invitee.full_name}" <#{@group_invite.invitee.email}>)
    attachments.inline["woof_logo.png"] = File.read("#{Rails.root}/app/assets/images/woof_logo.png")
    mail(to: email_with_name, subject: "#{@group_invite.inviter.email} has invited you on Woof") # "Group invite from Woof app"
  end
  
  def group_invite_new_user(group_invite)
    @group_invite = group_invite
    email_with_name = %("#{@group_invite.invitee.full_name}" <#{@group_invite.invitee.email}>)
    attachments.inline["woof_logo.png"] = File.read("#{Rails.root}/app/assets/images/woof_logo.png")
    mail(to: email_with_name, subject: "#{@group_invite.inviter.email} has invited you to join Woof")
  end
  
  def feedback(feedback)
    @feedback = feedback
    email_with_name = %("Woof Admin" <#{ENV['EMAIL_USERNAME']}>)
    mail(from: 'Woof app <contact@mywoofapp.com>', to: email_with_name, cc: "#{ENV['FEEDBACK_EMAIL_CC']}", subject: "Anonymous user feedback")
  end
  
  def event_invite(event_invite)
    @event_invite = event_invite
    email_with_name = %("#{@event_invite.invitee.full_name}" <#{@event_invite.invitee.email}>)
    attachments.inline["woof_logo.png"] = File.read("#{Rails.root}/app/assets/images/woof_logo.png")
    mail(to: email_with_name, subject: "#{@event_invite.inviter.email} has invited you on Woof") # "Event invite from Woof app"
  end
end

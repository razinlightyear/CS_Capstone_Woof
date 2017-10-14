class UserMailer < ApplicationMailer
  
  def confirm_account(user)
    @user = user
    email_with_name = %("#{@user.first_name} #{@user.last_name}" <#{@user.email}>)
    mail(to: email_with_name, subject: 'Welcome to Woof') #.deliver_later
  end
end

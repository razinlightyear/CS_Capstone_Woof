# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def confirm_account
    UserMailer.confirm_account(User.first)
  end
end

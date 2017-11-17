SanitizeEmail::Config.configure do |config|
  config[:sanitized_to] =         ENV['EMAIL_USERNAME']
  config[:sanitized_cc] =         ENV['EMAIL_USERNAME']
  config[:sanitized_bcc] =        ENV['EMAIL_USERNAME']
  # run/call whatever logic should turn sanitize_email on and off in this Proc:
  config[:activation_proc] =      Proc.new { %w(development test).include?(Rails.env) }
  config[:use_actual_email_prepended_to_subject] = true         # or false
  config[:use_actual_environment_prepended_to_subject] = true   # or false
  config[:use_actual_email_as_sanitized_user_name] = true       # or false
end

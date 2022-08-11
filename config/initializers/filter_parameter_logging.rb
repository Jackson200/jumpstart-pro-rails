# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [
  :password,
  :email,
  :otp_attempt,
  :name,
  :first_name,
  :last_name,
  :current_sign_in_ip,
  :last_sign_in_ip
]

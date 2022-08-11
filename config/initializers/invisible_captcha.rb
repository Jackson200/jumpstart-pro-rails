InvisibleCaptcha.setup do |config|
  config.timestamp_enabled = !Rails.env.test?

  if Rails.env.test?
    config.honeypots = ["honeypotx"]
  end
end

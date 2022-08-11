if Rails.env.production? || Rails.env.staging?
  Sentry.init do |config|
    config.dsn = Rails.application.credentials.dig(:sentry, :dsn)
    config.send_default_pii = true
    config.rails.report_rescued_exceptions = true
    config.breadcrumbs_logger = [:active_support_logger]
  end
end

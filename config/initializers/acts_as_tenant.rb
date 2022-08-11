# ActsAsTenant configuration - https://github.com/excid3/acts_as_tenant
# Use this to configure how multitenancy works if you're using it.

require "acts_as_tenant/sidekiq" if defined? Sidekiq

ActsAsTenant.configure do |config|
  config.require_tenant = false
end

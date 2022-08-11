# Sudo forces users to confirm their password when accessing an important part of your application
#
# Usage:
#
# Simply include `before_action :sudo` on the controller actions you want to protect
#
module Users
  module Sudo
    extend ActiveSupport::Concern

    # Default length of sudo sessions
    mattr_accessor :sudo_duration, default: 30.minutes

    def sudo(**options)
      return if valid_sudo?
      render "users/sudo/new"
    end

    def valid_sudo?
      return false if session[:sudo].blank?
      Time.parse(session[:sudo]) + @@sudo_duration > Time.current
    end

    def reset_sudo_session!
      session[:sudo] = nil
    end

    def extend_sudo_session!
      session[:sudo] = Time.current.to_s
    end
  end
end

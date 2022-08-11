module Jumpstart
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    include Users::TimeZone

    impersonates :user

    # Used for sharing flash between main app and gem
    def current_account
    end
    helper_method :current_account
  end
end

require_dependency "jumpstart/application_controller"

module Jumpstart
  class AdminController < ApplicationController
    def show
      @user = User.new
      @config = Jumpstart::Configuration.load!
      @omniauth_providers = Jumpstart::Omniauth.all_providers
    end
  end
end

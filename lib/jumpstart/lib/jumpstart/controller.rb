module Jumpstart
  module Controller
    extend ActiveSupport::Concern

    included do
      prepend_before_action :jumpstart_welcome, if: -> { Rails.env.development? }
    end

    def jumpstart_welcome
      redirect_to jumpstart.root_path(welcome: true) unless File.exist?(Rails.root.join("config", "jumpstart.yml"))
    end
  end
end

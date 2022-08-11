class Turbo::Android::PathConfigurationsController < ApplicationController
  # Defines the tabs and rules for the mobile app views
  # To customize this, you can edit the JSON here
  def show
    render json: {
      settings: {
        screenshots_enabled: true,
        register_with_account: Jumpstart.config.register_with_account?,
        require_authentication: false,
        # Tabs are hidden while we sort this out: https://github.com/hotwired/turbo-android/issues/209
        tabs: [
          {
            title: "Home",
            path: root_path,
            image_url: svg_icon_path("home")
          },
          {
            title: "What's New",
            path: announcements_path,
            image_url: svg_icon_path("announcement")
          },
          {
            title: "Notifications",
            path: notifications_path,
            image_url: svg_icon_path("notifications"),
            show_notification_badge: true
          }
        ].to_json
      },
      rules: [
        {
          patterns: [".*"],
          properties: {
            context: "default",
            uri: "turbo://fragment/web",
            fallback_uri: "turbo://fragment/web",
            pull_to_refresh_enabled: true
          }
        },
        {
          patterns: ["^$", "^/$"],
          properties: {
            uri: "turbo://fragment/web/home",
            presentation: "replace_root"
          }
        },
        {
          patterns: ["/new$", "/edit$"],
          properties: {
            context: "modal",
            uri: "turbo://fragment/web/modal/sheet",
            pull_to_refresh_enabled: false
          }
        },
        {
          patterns: ["/users/sign_in"],
          properties: {
            uri: "turbo://fragment/users/sign_in",
            context: "modal"
          }
        },
        {
          patterns: ["/users/sign_up"],
          properties: {
            uri: "turbo://fragment/users/sign_up",
            context: "modal"
          }
        },
        {
          patterns: ["/account/password/edit"],
          properties: {
            uri: "turbo://fragment/account/password/edit",
            context: "modal"
          }
        }
      ]
    }
  end

  private

  # Provide the name of the icon
  def svg_icon_path(icon)
    ActionController::Base.helpers.asset_path("icons/#{icon}.svg")
  end
end

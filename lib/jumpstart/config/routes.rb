Jumpstart::Engine.routes.draw do
  resource :admin, only: [:show]
  resource :config, only: [:create]
  resources :users, only: [:create]

  resource :docs do
    get :installation
    get :configuration
    get :upgrading
    get :deploying
    get :screencasts

    get :action_cable
    get :action_mailbox
    get :action_text
    get :active_storage
    get :admin
    get :announcements
    get :api
    get :authentication
    get :background_workers
    get :billing
    get :credentials
    get :cron
    get :databases
    get :development
    get :email
    get :i18n
    get :notifications
    get :oauth
    get :scaffolds
    get :accounts
    get :users

    get :alerts
    get :branding
    get :buttons
    get :cards
    get :forms
    get :icons
    get :javascript
    get :pagination
    get :pills
    get :tailwind
    get :typography
    get :wells

    get :existing_apps
    get :integrations
  end

  root to: "admin#show"
end

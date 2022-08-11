namespace :turbo do
  namespace :android do
    resource :path_configuration, only: :show
  end
  namespace :ios do
    resource :path_configuration, only: :show
  end
end

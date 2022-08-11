class Api::V1::MeController < Api::BaseController
  def show
    render partial: "users/user", locals: {user: current_user}
  end
end

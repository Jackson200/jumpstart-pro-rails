class PaymentsController < ApplicationController
  def show
    @payment = Pay::Payment.from_id(params[:id])
  end

  def update
    @payment = Pay::Payment.from_id(params[:id])
    @payment.confirm
    redirect_to root_path, notice: t(".success")
  end
end

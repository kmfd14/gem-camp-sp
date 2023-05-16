class Client::ShopsController < ApplicationController
  after_action :authenticate_client_user!, only: :show
  def index
    @offers = Offer.all
  end

  def show
    @offer = Offer.find(params[:id])
    @order = Order.new
  end

  def new; end

  def create
    @order = Order.new(order_params)
    @offer = Offer.active.find(params[:order][:offer_id])
    @order.user_id = current_client_user.id
    @order.offer_id = @offer.id
    @order.amount = @offer.amount
    @order.coin = @offer.coin
    if @order.save
      if @order.may_submit? && @order.submit!
        flash[:notice] = "Order submitted."
      else
        flash[:alert] = "Order submit failed."
      end
      redirect_to client_shops_path
    else
      render :show
    end
  end

  private

  def order_params
    params.require(:order).permit(:offer_id, :user_id, :remarks)
  end
end

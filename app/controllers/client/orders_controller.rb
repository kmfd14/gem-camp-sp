class Client::OrdersController < ApplicationController
  def cancel
    order = Order.find(params[:order_id])
    if order.cancel!
      flash[:notice] = "Order cancelled."
    else
      flash[:alert] = "Order cancel failed."
    end
    redirect_to client_profile_path(history: 'order_history')
  end
end

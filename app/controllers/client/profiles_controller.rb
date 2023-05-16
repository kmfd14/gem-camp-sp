class Client::ProfilesController < ApplicationController
  before_action :authenticate_client_user!

  def show
    @user = current_client_user
    @users = User.all
    @winner = Winner.where(user_id: @user)
    @order_history = @user.orders.order(created_at: :desc) if params[:history] == 'order_history'
    @lottery_history = @user.bets if params[:history] == 'lottery_history'
    @winning_history = @winner if params[:history] == 'winning_history'
    @invitation_history = @users.where(parent_id: @user) if params[:history] == 'invitation_history'
    # @user_order_history = current_client_user.orders.where(offer_id: @order.id)
  end
  def edit
    @user = current_client_user
  end

  def update
    @user = current_client_user
    if @user.update(user_params)
      redirect_to client_profile_path, notice: 'Profile updated successfully.'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :image, :email, :phone_number, :address)
  end
end

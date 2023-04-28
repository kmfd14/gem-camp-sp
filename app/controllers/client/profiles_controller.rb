class Client::ProfilesController < ApplicationController
  before_action :authenticate_client_user!

  def show
    @user = current_client_user
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

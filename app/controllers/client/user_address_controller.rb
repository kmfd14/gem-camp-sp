class Client::UserAddressController < ApplicationController
  before_action :set_address, only: [:edit, :update, :destroy]

  def index
    @user_addresses = current_client_user.user_address.all
  end

  def new
    @user_address = UserAddress.new
  end

  def create
    @user_address = UserAddress.new(address_params)
    @user_address.user = current_client_user
    if @user_address.save
      flash[:notice] = 'Address created successfully'
      redirect_to client_user_address_index_path
    else
      flash[:alert] = 'Address create failed'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user_address.update(address_params)
      flash[:notice] = 'Address Updated Successfully'
      redirect_to client_user_address_index_path
    else
      flash.now[:alert] = 'Address update failed'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user_address.destroy
    flash[:notice] = 'Address Deleted Successfully'
    redirect_to client_user_address_index_path
  end

  private

  def set_address
    @user_address = UserAddress.find(params[:id])
  end

  def address_params
    params.require(:user_address).permit(:is_default, :name, :genre, :street_address, :phone_number, :remark, :address_region_id, :address_province_id, :address_city_id, :address_barangay_id)
  end
end

class Client::WinnersController < ApplicationController
  def show
    @winner = Winner.find(params[:id])
    winner_address = UserAddress.find_by(user: @winner.user_id, is_default: 1)
    @address_name = winner_address.name
    street_name = winner_address.street_address
    barangay = winner_address.barangay.name
    city = winner_address.city.name
    province = winner_address.province.name
    region = winner_address.region.name
    @winner_address = "#{street_name}, #{barangay}, #{city}, #{province}, #{region}"
  end

  def claim
    winner = Winner.find(params[:id])
    if winner.claim!
      flash[:notice] = "[Success] - State: Claimed"
    else
      flash[:alert] = "[Failed] - State: Claimed"
    end
    redirect_to client_profile_path(history: 'winning_history')
  end
end
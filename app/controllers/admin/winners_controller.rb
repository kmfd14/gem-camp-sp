class Admin::WinnersController < ApplicationController
  def index
    @winners = Winner.all
    @winners = @winners.by_serial_number(params[:serial_number]) if params[:serial_number].present?
    @winners = @winners.by_email(params[:email]) if params[:email].present?
    @winners = @winners.by_state(params[:state]) if params[:state].present?
    @winners = @winners.by_date_range(params[:start_date].to_date..params[:end_date].to_date) if params[:start_date].present? && params[:end_date].present?
    @winner_addresses = get_winner_addresses(@winners)
  end

  def submit
    winner = Winner.find(params[:id])
    if winner.submit!
      flash[:notice] = "[Success] - State: Submitted"
    else
      flash[:alert] = "[Failed] - State: Submitted"
    end
    redirect_to admin_winners_path
  end

  def pay
    winner = Winner.find(params[:id])
    if winner.pay!
      flash[:notice] = "[Success] - State: Paid"
    else
      flash[:alert] = "[Failed] - State: Paid"
    end
  end

  def ship
    winner = Winner.find(params[:id])
    if winner.ship!
      flash[:notice] = "[SUCCESS] - State: Shipped"
    else
      flash[:alert] = "[Failed] - State: Shipped"
    end
  end

  def deliver
    winner = Winner.find(params[:id])
    if winner.deliver!
      flash[:notice] = "[SUCCESS] - State: Deliver"
    else
      flash[:alert] = "[Failed] - State: Deliver"
    end
  end

  def publish
    winner = Winner.find(params[:id])
    if winner.publish!
      flash[:notice] = "[Success] - State: Publish"
    else
      flash[:alert] = "[Failed] - State: Publish"
    end
  end

  def remove_publish
    winner = Winner.find(params[:id])
    if winner.remove_publish!
      flash[:notice] = "[Success] - State: Remove Publish"
    else
      flash[:alert] = "[Failed] - State: Remove Publish"
    end
  end

  def get_winner_addresses(winners)
    winner_addresses = {}
    winners.each do |winner|
      winner_address = UserAddress.find(winner.address_id)
      street_name = winner_address.street_address
      barangay = winner_address.barangay.name
      city = winner_address.city.name
      province = winner_address.province.name
      region = winner_address.region.name
      winner_addresses[winner.id] = "#{street_name}, #{barangay}, #{city}, #{province}, #{region}"
    end
    winner_addresses
  end
end

class Client::ClaimsController < ApplicationController

  def show
    @winner = Winner.find(params[:id])
  end

  def update
    @winner = Winner.find(params[:id])
    if @winner.update(address_params) && @winner.may_claim? && @winner.claim!
      flash[:notice] = "[Success] - Successfully claimed the prize."
      redirect_to client_profile_path(winner: :winners)
    else
      flash[:alert] = "[Error] - Failed to claim prize."
      redirect_to client_claim_path
    end
  end

  private

  def address_params
    params.require(:winner).permit(:address_id)
  end
end

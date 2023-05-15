class Admin::OffersController < ApplicationController
  before_action :set_offer, only: [:edit, :update, :destroy]
  def index
    @offers = Offer.all
    @offers = @offers.by_genre(params[:genre]) if params[:genre].present?
    @offers = @offers.by_status(params[:status]) if params[:status].present?
  end

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(offer_params)
    if @offer.save
      flash[:notice] = 'Offer added successfully'
      redirect_to admin_offers_path
    else
      flash[:notice] = 'Add offer failed'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @offer.update(offer_params)
      flash[:notice] = 'Offer updated successfully'
      redirect_to admin_offers_path
    else
      flash.now[:alert] = 'Update offer failed'
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def set_offer
    @offer = Offer.find(params[:id])
  end
  def offer_params
    params.require(:offer).permit(:image, :name, :genre, :amount, :coin)
  end
end

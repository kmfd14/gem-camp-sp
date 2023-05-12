class Client::LotteryController < ApplicationController
  after_action :authenticate_client_user!, only: :show
  def index
    @items = Item.active.starting.includes(:categories)
    @items = @items.filter_by_category(params[:category]) if params[:category].present?
  end

  def show
    @item = Item.find(params[:id])
    @user_bets = current_client_user.bets.where(item_id: @item.id).order(created_at: :desc) if params[:item_id].present?
    @bet = Bet.new
  end

  def create
    # render json: params
    @tickets = params[:bet][:coins].to_i
    if @tickets.times do
      @bet = Bet.new(bet_params)
      @item = Item.find(params[:bet][:item_id])
      @bet.user_id = current_client_user.id
      @bet.item = @item
      @bet.batch_count = @item.batch_count
      @bet.save
    end
      flash[:notice] = 'You have bet on this item.'
    else
      flash[:notice] = 'Bet failed.'
    end
    redirect_to client_lottery_index_path
  end

  private

  def bet_params
    params.require(:bet).permit(:item_id)
  end
end

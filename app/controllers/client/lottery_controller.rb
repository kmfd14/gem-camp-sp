class Client::LotteryController < ApplicationController

  def index
    @items = Item.active.starting.includes(:categories)
    @items = @items.filter_by_category(params[:category]) if params[:category].present?
  end

  def show
    @item = Item.find(params[:id])
  end
end

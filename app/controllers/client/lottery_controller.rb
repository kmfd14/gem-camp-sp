class Client::LotteryController < ApplicationController

  def index
    @items = Item.includes(:categories)
    @items = @items.filter_by_category(params[:category]) if params[:category].present?
  end
end

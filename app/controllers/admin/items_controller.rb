class Admin::ItemsController < ApplicationController

  def index
    @items = Item.all
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:notice] = 'Item added successfully'
      redirect_to admin_items_path
    else
      flash[:notice] = 'Add items failed'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @item.update(address_params)
      flash[:notice] = 'Item updated successfully'
      redirect_to admin_items_path
    else
      flash.now[:alert] = 'Update items failed'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:image, :name, :quantity, :minimum_bets, :batch_count, :online_at, :offline_at, :start_at,:status)
  end
end

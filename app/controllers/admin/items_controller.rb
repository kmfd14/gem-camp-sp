class Admin::ItemsController < ApplicationController
  before_action :set_item, only: [:edit, :update, :destroy]
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
    if @item.update(item_params)
      flash[:notice] = 'Item updated successfully'
      redirect_to admin_items_path
    else
      flash.now[:alert] = 'Update items failed'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    flash[:notice] = 'Item Deleted Successfully'
    redirect_to admin_items_path
  end

  def start
    item = Item.find(params[:id])
    item.batch_count = 0
    if item.start!
      item.update(quantity: item.quantity - 1, batch_count: item.batch_count + 1)
      flash[:notice] = 'Item started.'
    else
      flash[:alert] = "Item start failed."
    end
    redirect_to admin_items_path
  end

  def pause
    item = Item.find(params[:id])
    if item.pause!
      flash[:notice] = 'Item paused.'
    else
      flash[:alert] = "Item pause failed."
    end
    redirect_to admin_items_path
  end

  def end
    item = Item.find(params[:id])
    if item.end!
      flash[:notice] = "Item ended."
    else
      flash[:alert] = "Item end failed"
    end
    redirect_to admin_items_path
  end

  def cancel
    item = Item.fid(params[:id])
    if item.cancel!
      flash[:notice] = "Item cancelled."
    else
      flash[:alert] = "Item cancel failed."
    end
    redirect_to admin_items_path
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:image, :name, :quantity, :minimum_bets, :batch_count, :online_at, :offline_at, :start_at,:status)
  end
end

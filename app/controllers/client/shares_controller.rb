class Client::SharesController < ApplicationController
  def index
    @shares = Winner.where(state: :published)
  end
end

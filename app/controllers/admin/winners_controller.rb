class Admin::WinnersController < ApplicationController
  def index
    @winners = Winner.all
  end
end

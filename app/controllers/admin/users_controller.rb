class Admin::UsersController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :check_admin
  before_action :find_parent_user, only: :create

  def create
    super
  end

  def index
    @users = User.client.includes(:parent).all
  end

  def check_admin
    raise ActionController::RoutingError.new('Not Found') unless current_admin_user.admin?
  end

  private

  def find_parent_user
    if cookies[:promoter_email].present?
      parent_user = User.find_by(email: cookies[:promoter_email])
      if parent_user.present?
        resource.parent_id = parent_user.id
      end
    end
  end
end

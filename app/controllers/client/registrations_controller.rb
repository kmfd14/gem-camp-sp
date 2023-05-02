# frozen_string_literal: true

class Client::RegistrationsController < Devise::RegistrationsController
  before_action :set_promoter_cookie
  def new
    super
  end
  def create
    super do |resource|
      promoter = User.find_by(email: cookies[:promoter_email])
      resource.parent_id = promoter.id if promoter.present?
      resource.save
    end
  end

  private

  def set_promoter_cookie
    if params[:promoter].present?
      cookies[:promoter_email] = params[:promoter]
    end
  end
end

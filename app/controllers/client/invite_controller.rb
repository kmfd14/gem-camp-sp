class Client::InviteController < ApplicationController

  def index
    @user = current_client_user
    @promotion_link = generate_promotion_link(@user.email)
    @qr_code = generate_promotion_qr(@promotion_link)
  end

  def generate_promotion_qr(promotion_link)
    require "rqrcode"

    qrcode = RQRCode::QRCode.new(promotion_link)

    # NOTE: showing with default options specified explicitly
    svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 7,
      standalone: true,
      use_path: true
    )
  end

  def generate_promotion_link(user_email)
    base_url = "http://client.com/users/sign_up"
    promoter_param = "promoter=#{user_email}"
    promotion_link = "#{base_url}?#{promoter_param}"
    return promotion_link
  end
end

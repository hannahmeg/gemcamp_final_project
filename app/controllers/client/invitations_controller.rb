class Client::InvitationsController < ClientController
  def generate_qr_code
    promoter_email = params[:promoter]
    sign_up_url = "#{request.base_url}/users/sign_up?promoter=#{promoter_email}"
    qr = RQRCode::QRCode.new(sign_up_url)
    qr_code_svg = qr.as_svg(module_size: 4)
    send_data qr_code_svg, type: 'image/svg+xml', disposition: 'inline'
  end
end

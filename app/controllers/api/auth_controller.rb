class Api::AuthController < ApplicationController
  def request_link
    email = params[:email]&.downcase&.strip
    return render json: { error: "Email required" }, status: :unprocessable_entity if email.blank?

    guest = Guest.find_or_initialize_by(email: email)
    unless guest.valid? || guest.persisted?
      return render json: { error: "Invalid email" }, status: :unprocessable_entity
    end
    guest.save! if guest.new_record?

    token = guest.generate_auth_token!
    GuestMailer.magic_link(guest, token).deliver_now

    render json: { message: "Check your email for a login link" }
  rescue => e
    Rails.logger.error("Magic link error: #{e.message}")
    render json: { error: "Failed to send email. Please try again." }, status: :service_unavailable
  end

  def verify
    token = params[:token]
    guest = Guest.find_by(auth_token: token)

    if guest.nil?
      return render json: { error: "Invalid or expired link" }, status: :unauthorized
    end

    session_token = guest.authenticate_token!(token)
    if session_token
      render json: { session_token: session_token, email: guest.email }
    else
      render json: { error: "Link has expired" }, status: :unauthorized
    end
  end

  def me
    require_guest!
    return if performed?
    render json: {
      email: current_guest.email,
      voted_singing: current_guest.voted_for?("singing"),
      voted_costume: current_guest.voted_for?("costume"),
      voting_open: Setting.voting_open?
    }
  end
end

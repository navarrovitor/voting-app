class Api::AuthController < ApplicationController
  def login
    code = params[:code]&.upcase&.strip
    return render json: { error: "Code required" }, status: :unprocessable_entity if code.blank?

    contestant = Contestant.find_by(code: code)
    return render json: { error: "Código inválido" }, status: :unauthorized unless contestant

    contestant.update!(present: true) unless contestant.present?

    guest = Guest.find_or_create_by!(identifier: code) { |g| g.contestant = contestant }
    guest.update!(session_token: SecureRandom.urlsafe_base64(32))

    render json: { session_token: guest.session_token, name: contestant.name }
  end

  def me
    require_guest!
    return if performed?
    render json: {
      name: current_guest.contestant&.name,
      voted_singing: current_guest.voted_for?("singing"),
      voted_costume: current_guest.voted_for?("costume"),
      voting_open: Setting.voting_open?
    }
  end
end

class ApplicationController < ActionController::API
  def current_guest
    @current_guest ||= begin
      token = request.headers["Authorization"]&.sub(/^Bearer /, "")
      Guest.find_by(session_token: token) if token.present?
    end
  end

  def require_guest!
    render json: { error: "Unauthorized" }, status: :unauthorized unless current_guest
  end
end
